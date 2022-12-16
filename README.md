# fabric-cloud-infrastructure
Repo with CI/CD pipeline to setup a network with multiple organizations

## K8S Clusters

You'll need to have some clusters created and already ready to go. You'll need to know the storage classes for these and the external domain of the public endpoint of the cluster. 

To adopt for your own cluster look out for <YOUR_CLUSTER_INFO> for places where you might need to provide cluster vendor specific information. For testing this repo been preset to push to a IBM VPC K8S Cluster.

- Clone this repo
- Get an API key/ Cluster Config as per your vendor to permit remote management of the cluster
- Use the configured GHA pipelines for the major actions set out below

## Cluster Bootstrap setup steps

*DockerImages:*
You may need to preload the docker images to a registry accesible to your cluster.

> Run the `001-containerimage-preload` pipeline

*CRDs & Operator & Console:*

The CRDs and Fabric Operator needs to be installed once per cluster; the console is often installed
at the same time - and at the moment is needed for the rest of the Ansible playbooks (for the moment!)

> Run the `002-crds-operator` pipeline

