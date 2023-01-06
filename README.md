# fabric-cloud-infrastructure
> This repository contains suggested Github Actions CI/CD workflows that use Ansible Playbooks to stand up a multi-ogranization fabric network. 

Check for workflows that do the following:

- uploading the required docker images to the cluster's registry, 
- creating the K8S CRDs and Operators
- installing the Fabric Operations Console
- setting up a Fabric Network 
- .. and more

This repo is in effect a gitops repo, the idea being that there is a repo that contains the configuration and playbooks 
that are then applied to the cluster(s). Updates to this configuration will use Ansible to update the configuration.

## Workflow Structure

Each workflow has the same basic structure

1. clone this repo 
2. obtain a working copy of arcitecture configuration and topology for the organization
3. login & get access information for the K8S cluster
4. run the playbooks to configure the required resources

All the playbooks are assuming that the configuration to act on is in  in the `${ROOT}/_cfg` directory.
Also any identities/connection information created are stored in this file. In reality these identities etc. should be uploaded to secure locations before the worflow ends

## K8S Clusters

You'll need to have some clusters created and already ready to go. You'll need to know the storage classes for these and the external domain of the public endpoint of the cluster. 

There are workflow examples for running with a IBM IKS-VPC cluster - and also with KIND. The KIND cluster is also run on PR runs of this repo itself.

## To adopt to your scenario...

## Cluster Configuration Steps

*Prepare Configuration:*

Example configurations are present for iks_vpc and kind clusters, this needs to be copied into the `${ROOT}/_cfg` directory. (in your own pipeline of course you can put these files where you wish)

> All the workflows just a plain file copy of the configuration to the _cfg directory

*DockerImages:*

You may need to preload the docker images to a registry accesible to your cluster.

> Look at the the [`001-containerimage-preload`](.github/workflows/001-containerimage-preload.yaml) pipeline

*CRDs & Operator & Console:*

The CRDs and Fabric Operator needs to be installed once per cluster; the console is often installed
at the same time - and at the moment is needed for the rest of the Ansible playbooks (for the moment!)

> Look at the [`002-crds-operator`](.github/workflows/002-crds-operator.yaml) pipeline

> To run locally: 
```
ansible-playbook -e ROOT=$(pwd) ./playbooks/operator_console_playbooks/01-operator-install.yml
ansible-playbook -e ROOT=$(pwd) ./playbooks/operator_console_playbooks/02-console-install.yml
```


---

## Local Demo Scenario

**Start KIND**

```
./scripts/kind_with_nginx.sh


```

**Copy the configuration**

```
find ./architecture -name "*.yml" -exec cp {} _cfg \;
mv _cfg/operator-console-kind-vars.yml _cfg/operator-console-vars.yml
echo "console_domain: localho.st" >> _cfg/domain.yml
```

**Run the playbooks**

Easiest way to do this is the same way as the github action does, first build the docker container as the GHA does

```
cd fabric-ansible-action
docker build -t gaa .
```

Each playbook can now be run like this:

```
docker run -it --network host -v $(pwd):/github/workspace -e GITHUB_WORKSPACE=/github/workspace gaa <PLAYBOOKS HERE>
```

```.runpb 

