# fabric-cloud-infrastructure
This repository contains suggested Github Actions CI/CD workflows that use Ansible Playbooks to stand up a multi-ogranization fabric network. There are workflows for 

- uploading the required docker images to the cluster's registry, 
- creating the K8S CRDs and Operators
- installing the Fabric Operations Console
- setting up a Fabric Network 
- .. and more

Each workflow has the same basic structure

1. clone this repo
2. obtain a working copy of arcitecture configuration and topology for the organization
3. login & get access information for the K8S cluster
4. run the playbooks to configure the required resources



## K8S Clusters

You'll need to have some clusters created and already ready to go. You'll need to know the storage classes for these and the external domain of the public endpoint of the cluster. 

To adopt for your own cluster look out for <YOUR_CLUSTER_INFO> for places where you might need to provide cluster vendor specific information. As an example pipelines have been created to target to a IBM VPC K8S Cluster.

### To adopt to your scenario...

### Configuration Location

All the configuration needed and identities etc created are in the `${ROOT}/_cfg` directory.


## Cluster Configuration Steps

*Prepare Configuration:*
Example configurations are present for iks_vpc and kind clusters, this needs to be copied into the `${ROOT}/_cfg` directory. (in your own pipeline of course you can put these files where you wish)


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

## Hyperledger Fabric Consortium Creation

*Creating OrganizationOne:*




