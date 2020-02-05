# multistage-docker

The Docker Build

The Docker file in the repo contains a multistage build that will install the updates and the java cert tool copy the certificate
The second stage will use the updated keystore produced in the first step and copy it across. It has been confirmed that the certificate was successfully added

Updates are installed during the `artifact` stage ensuring that layer caching is used in case the docker build command needed to be run again. Furthermore the RUN statements are combined so that no new layer us created at each command

{code}
TNDEV28:multistage-docker nirol$ docker build   -t multistage:latest  .
Sending build context to Docker daemon  78.85kB
Step 1/9 : FROM openjdk:9-jdk-slim as artifact
 ---> 339dc16e8d08
Step 2/9 : RUN apt-get update     && apt-get install --no-install-recommends -y -qq ca-certificates-java
 ---> Using cache
 ---> 531f4fab6e97
{code}

K8s Deployment

For this requirement I have chosen to use helm charts. A chart `javacert` has been uploaded to the repo. However under the circumstances that helm isn't available I have also included the manifests in a `manifests` folder
The script `kube_deploy.sh` will check for the existence of helm and then deploy appropriately
The kube deployment creates the following
    - Namespace
    - ServiceAccount
    - Deployment
    - Service
    - ReplicaSet

Working with Helm Charts is incredibly easy as all changes are parameter driven from the values.yaml file.

The reason behind including a ReplicaSet was the fact that there was no application listening on any port for this Docker image. In an ecosystem where it is a Service Oriented Architecture there would be backend application that could merely be doing the gruntwork. Hence running a replicaSet to show the ability to do so. 

With the above deployment of Kube resources it is quite easy to Scale resources with a single command and can be driven of performance metrics

Assuming only this deployment is running
{code}
kubectl scale --replicas=3 $(kubectl get deployments -n technical-test -o name) -n technical-test
{code}