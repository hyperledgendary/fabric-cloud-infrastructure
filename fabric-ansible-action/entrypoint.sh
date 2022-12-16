#!/usr/bin/env bash
#
# SPDX-License-Identifier: Apache-2.0
#
set -xeuo pipefail

# env | sort
# ls -lart
# ls -lart _cfg

# # If this image is run with -u <random UID>, as happens on Red Hat OpenShift, then
# # the user is not in the /etc/passwd file. This causes Ansible to fail, so we need
# # to add the user to /etc/passwd now before Ansible runs.
# if ! whoami &> /dev/null; then
#     sed '/ibp-user/d' /etc/passwd > /tmp/passwd
#     cat /tmp/passwd > /etc/passwd
#     rm -f /tmp/passwd
#     echo "ibp-user:x:$(id -u):0::/home/ibp-user:/bin/bash" >> /etc/passwd
#     export HOME=/home/ibp-user
# fi
export PYTHONPATH=/home/ibp-user/.local/lib/python3.9/site-packages
export HOME=/home/ibp-user
cd ${HOME}

export KUBECONFIG="${GITHUB_WORKSPACE}/_cfg/k8s_context.yaml"

# Run a shell or the specified command.
if [ $# -eq 0 ]; then
    exec /bin/bash
else
    ansible-playbook -e ROOT=${GITHUB_WORKSPACE} ${GITHUB_WORKSPACE}/${INPUT_PLAYBOOK}
fi
