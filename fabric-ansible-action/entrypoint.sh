#!/usr/bin/env bash
#
# SPDX-License-Identifier: Apache-2.0
#
set -xeuo pipefail
export INPUT_PLAYBOOK=$1
export ARGSFILE=${2:-none}

echo $INPUT_PLAYBOOK
echo $ARGSFILE

echo $GITHUB_WORKSPACE
whoami
pwd

export PYTHONPATH=/home/ibp-user/.local/lib/python3.9/site-packages
export HOME=/home/ibp-user
# cd ${HOME}

export KUBECONFIG="${GITHUB_WORKSPACE}/_cfg/k8s_context.yaml"

export IBP_ANSIBLE_LOG_FILENAME=${GITHUB_WORKSPACE}/_cfg/__ansible.log

if [[ $ARGSFILE == "none" ]]; then
    ansible-playbook -e ROOT=${GITHUB_WORKSPACE} ${GITHUB_WORKSPACE}/${INPUT_PLAYBOOK}
else
    ansible-playbook -e ROOT=${GITHUB_WORKSPACE} --extra-vars "@${GITHUB_WORKSPACE}/${ARGSFILE}" ${GITHUB_WORKSPACE}/${INPUT_PLAYBOOK} 
fi
