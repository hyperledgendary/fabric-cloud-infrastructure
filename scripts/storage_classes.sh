#!/usr/bin/env bash
set -x -e -u -o pipefail
cd "$(dirname "$0")"

#OCP_PASSWORD=$(jq -r '.clusters[0].kubeadmin_password' ocpdetails.json)
oc login https://api.${FYRE_OCP_NAME}.cp.fyre.ibm.com:6443 --password ${OCP_PASSWORD} --username kubeadmin --insecure-skip-tls-verify=true


URL=https://github.com/rook/rook.git
# For fyre, the storage classes need to be setup first
FOLDER=rook
if [ -d "$FOLDER" ] ; then
  rm -rf $FOLDER
fi
git clone --single-branch --branch v1.6.0 $URL $FOLDER

cd rook/cluster/examples/kubernetes/ceph
oc create -f crds.yaml
oc create -f common.yaml
oc create -f operator-openshift.yaml
oc create -f cluster.yaml
oc create -f ./csi/rbd/storageclass.yaml
oc create -f ./csi/rbd/pvc.yaml
oc create -f filesystem.yaml
oc create -f ./csi/cephfs/storageclass.yaml
oc create -f ./csi/cephfs/pvc.yaml
oc create -f toolbox.yaml
cd -
