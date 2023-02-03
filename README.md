# fabric-cloud-infrastructure
> This repository contains suggested Github Actions CI/CD workflows that use Ansible Playbooks to stand up a multi-ogranization fabric network. 

Check this repo for workflows that offer the following:

- uploading the required docker images to the cluster's registry, 
- creating the K8S CRDs and Operators
- installing the Fabric Operations Console
- setting up a Fabric Network 
- .. and more

This repo is in effect a **gitops repo**, the idea being that there is a repo that contains the configuration and playbooks 
that are then applied to the cluster(s). Updates to this configuration will use Ansible to update the configuration.

As Fabric is a **Distributed System**  it is expected that will be a central architecture definition of the whole solution. Each organization that is running nodes executing configuration of same architecture but with variances for their own clusters. This repo then might be shared between Org1 and Org2, but run in different pipelines targetting different clusters. 

## Workflow Structure

Each workflow has the same basic structure

1. clone this repo - standard process
2. login & get access information for the K8S cluster
    - very specific of course to the cluster you are using
3. obtain a working copy of architecture, configuration and topology for your organization
    - this might mean pulling information about your local organization - so the runs here are specific to your org 
    - you may need to generate some of the configuration from templates
4. run the playbooks to configure the required resources
    - based on the working copy of the configuration

All the playbooks are assuming that the configuration to act on is in  in the `${ROOT}/_cfg` directory.
Also any identities/connection information created are stored in this file. In reality these identities etc. should be uploaded to secure locations before the worflow ends

Remember you'll need to have some clusters created and already ready to go. You'll need to know the storage classes for these and the external domain of the public endpoint of the cluster. 

## Example Configuration 

There are workflow examples for running with a IBM IKS-VPC cluster - and also with KIND. With KIND you can run this locally on your own laptop. The KIND cluster is also run on PR runs of this repo itself.

---

# The Workflows
## Uploading Docker Images to the cluster

You may need to preload the docker images to a registry accesible to your cluster;  this workflow uses a list of image names to load up to the cluster.

>  [`001-iksvpc-containerimage-preload`](.github/workflows/001-iskvpc-containerimage-preload.yaml) pipeline

## Creating the Fabric Operator CRDs and Fabric Operations Console

This workflow will create the CRDs and install the Fabric Operator; after loging into the cluster it will use the GithubActions Ansible task to run the playbook specified.

> Look at the [`002-iksvpc-crds-operator`](.github/workflows/002-crds-operator.yaml) pipeline

The 'Ansible Action' is invoked like this
```
      - name: Create the Fabric CRDs/Operator
        id: operatorinstall
        uses: hyperledgendary/fabric-ansible-action:v0.0.1
        with:
          playbook: playbooks/operator_console_playbooks/01-operator-install.yml
```

The playbook `playbooks/operator_console_playbooks/01-operator-install.yml` will be executed here using the configuration located within the `_cfg` directory. If you wish to change the location of the configuration please do so, but remember to alter the references in the playbooks.

Similarly the `playbooks/operator_console_playbooks/02-console-install.yml` playbook setups the Fabric Operations Console.


---
## Local Demo Scenario

| just command            | action                                          |
|-------------------------|-------------------------------------------------|
| `just kind`             | Start local KIND cluster                        |
| `just sail [<target>]`  | Create the configurationm with optional target. |
| `just runpb <playbook>` | Run the specified playbook                      |

Default configuration is use the `just sail kind` target for running locally in KIND with the OpenSource components
`just sail hlfsupport-kind` will run in KIND but with the IBM HLF Support Images

For OpenSource Stack the playbooks you can run are:

```
just runpb ./playbooks/operator_console_playbooks/01-operator-install.yml
just runpb ./playbooks/operator_console_playbooks/02-console-install.yml
```

For the IBM HLF Support the playbooks you should run are:
```
just runpb playbooks/hlfsupport_operator_console_playbooks/01-operator-install.yml
just runpb playbooks/hlfsupport_operator_console_playbooks/02-console-install.yml
```

After that you can run the Fabric Network playbooks

```
just runpb ./playbooks/fabric_network_playbooks/00-org1.yml
just runpb ./playbooks/fabric_network_playbooks/01-org2.yml
```

