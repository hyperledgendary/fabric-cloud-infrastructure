#
# Copyright contributors to the Hyperledgendary Full Stack Asset Transfer project
#
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
#
# 	  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Main justfile to run all the development scripts
# To install 'just' see https://github.com/casey/just#installation


###############################################################################
# COMMON TARGETS                       `                                       #
###############################################################################


# Ensure all properties are exported as shell env-vars
set export

# set the current directory, and the location of the test dats
CWDIR := justfile_directory()

_default:
  @just -f {{justfile()}} --list

kind:
    #!/bin/bash
    set -ex -o pipefail

    rm -rf {{CWDIR}}/_cfg && mkdir -p {{CWDIR}}/_cfg
    {{CWDIR}}/.github/scripts/kind_with_nginx.sh

# Shut down the KIND cluster
unkind:
    #!/bin/bash
    kind delete cluster --name kind

    if docker inspect kind-registry &>/dev/null; then
        echo "Stopping container registry"
        docker kill kind-registry
        docker rm kind-registry
    fi

sail target="kind":
    #!/bin/bash
    set -ex -o pipefail


    find {{CWDIR}}/architecture -name "*.yml" -exec cp {} {{CWDIR}}/_cfg \;
    mv {{CWDIR}}/_cfg/operator-console-{{target}}-vars.yml {{CWDIR}}/_cfg/operator-console-vars.yml
    echo "console_domain: localho.st" >> {{CWDIR}}/_cfg/domain.yml

    cp {{CWDIR}}/architecture/public/asset-transfer-basic-typescript.tgz _cfg/

# Creates a new identity for an application to use
runpb playbook:
    #!/bin/bash
    set -ex -o pipefail
    
    (docker inspect gaa > /dev/null) ||docker build -t gaa -f {{CWDIR}}/fabric-ansible-action/Dockerfile {{CWDIR}}/fabric-ansible-action

    docker run -it --rm --network host -v {{CWDIR}}:/github/workspace -e GITHUB_WORKSPACE=/github/workspace gaa {{playbook}} _cfg/domain.yml

runlocal:
    #!/bin/bash
    set -xe

    # clear out the configuration
    rm -f _cfg && mkdir -p _cfg

    # let's assume a KIND cluster running locally
    just kind

    # Get the Organizations' private configuration along with the public configuration
    just sail


    # install the operator and console
    # (assuming in this case they are running in the same cluster, so this is needed just once)
    just runpb playbooks/operator_console_playbooks/01-operator-install.yml
    just runpb playbooks/operator_console_playbooks/02-console-install.yml

    # Creat the Fabric components needed per organization
    just runpb playbooks/fabric_network_playbooks/00-org1.yml
    just runpb playbooks/fabric_network_playbooks/01-org2.yml


