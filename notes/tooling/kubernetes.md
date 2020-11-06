# Kubernetes (K8s)

An system for automating deployment, scaling and management of containerised applications on a group or
cluster of server machines; a container orchestrator.

It groups containers that make up an application into logical units to ease management and discovery.

Increases portability of your applications; same settings can THEORETICALLY be used anywhere (cloud, any
OS, etc.).


## Terminology

__Pod__; a group of one or more containers with shared storage/network and specifications for how to run the containers and it represents one running process on your cluster.

__Node__; serves as a worker machine (computer or virtual machine) in a k8s cluster.

__Cluster__; a set of node machines for running containerised applications.

__Controller__; a control loop is a non-terminating loop that regulates the state of a system e.g. a thermostat regulating temp.

## Architecture

```
                         +-------------------------------------+
    +--------+           |           Master Node               |         
    |Kubectl +-------------------+                             |
    +--------+           |       >--------------+              |            +------------+
                         |        |  API Server +----------------+          |            |         +------+
     +------<---------------------+             <------------+ | |          |  Internet  +-------->+ User |
     |etcd |             |        +--^--------^-+            | | |          |            |         +------+
     +-----+             |           |        |              | | |          +------------+
                         |           |        |              | | |                      |    
                         |    +---------+   +-----------+    | | |                      |   
                         |    |Scheduler|   |Controller |    | | |                      |   
                         |    |         |   |Manager    |    | | |                      |      
                         |    +---------+   +-----------+    | | |                      |        
                         |                                   | | |                      |      
                         +-------------------------------------+ |                      |          
                                                             |   |                      |         
                                                             |   |                      |             
                                                     +----------------------------------|-------------------+
                                                     |       |   |         Work Node    |                   |
                                                     |       |   |                      v                   |
                                                     |     +-----v-+                    +-----------+       |
                                                     |     |Kubelet|                    | Kube-Proxy|       |
                                                     |     |       |                    |           |       |
                                                     |     +-------+                    +-----------+       |
                                                     |       |                              |               |
                                                     | +--------------------------------------------------+ |
                                                     | |     v             Docker           v             | |
                                                     | |                                                  | |
                                                     | |      Pod             Pod             Pod         | |
                                                     | |  +---------+     +---------+     +---------+     | |
                                                     | |  |Container| x3  |Container| x3  |Container| x3  | |
                                                     | |  +---------+     +---------+     +---------+     | |
                                                     | |                                                  | |
                                                     | +--------------------------------------------------+ |
                                                     |                                                      |
                                                     +------------------------------------------------------+
```

## Master Nodes

Responsible for the overall management of the k8 cluster.

Three components that take care of communication, scheduling and controllers:

  - Api Server; allows you to interact with the K8s API.

  - Scheduler; allow one to watch created pods and designs the pod to run on a specific node.

  - Controller Manager; manage background threads that run tasks in a cluster.

ETCD; a key value store which is utilised as the K8 database by the master node. Pod details, job sceduling info etc. are stored here.

Kuberctl; a command line tool to communicate with the master node.

## Worker Nodes

Work nodes communicate with the master nodes API server via the Kubelet process.

### Kubelet

Manages pods it has been assigned.

Specifically:
  - checks if pods have been assigned to nodes, via the API server
  - mounts & runs pod volumes & secrets
  - executes health checks to identify pod/node status

Podspec; the YAML file that describes/configures the pod.

The api server provides podspecs and the nodes kubelet ensures the containers described are running/healthy.

### Kube Proxy

A network proxy and load balancer for the service on a single work node.

## Pod

A group of one or more containers with a shared storage/network and specifications for how to run
containers and it represents one running process on your cluster.

A pod represents a single instance of an application.

It contains:
    
  - Docker app container
  - Storage Resources
  - Unique Network IP
  - Options that govern how the container should be run

They are ephemeral/displosable

Always interface with a pod directly but instead via a controller.


### States

- Pending; container is yet to be created
- Running; where a pod has been scheduled on a node, containers are created and some are running.
- Succeeded; all containers in the pod have exited with an exit status of zero.
- Failed; all containers have exited and at least one has failed (returned a non-zero exit status)
- CrashLoopBackOff; container fails to start but k8s tries to restart the pod infinitely.

## Controllers

They help with:

  - App Reliability
  - Scaling
  - Load Balancing

Types of controllers:
  - ReplicaSets; ensures that a specified number of identical pods are available at all times.
  - Deployment; aligns pods and ReplicaSets with the desired deployment state provided by the user.
  - Replication (deprecated); used before ReplicaSets/Deployment controllers existed.
  - DaemonSets; ensures that all nodes run a copy of a specified pod.
  - Jobs; like cron job processes for pods.
  - Services; facilitates communication between pods in different deployments.

Deployment ----> ReplicaSet ----> Pod

## Labelling

Labels; key/value pairs that can be attached to pods/services/deployments.

Examples:

```
"release": "stable"
"environment": "dev"
```

Selectors; operators for labels via the command line.

Namespaces; label for multiple virtual clusters backed by the same physical cluster.

## Tooling

### Helm

A package manager for kubernetes.

Helm charts help you define, install and upgrade kubernetes applications.

A chart is a collection of files that describe a related set of k8s resources.

Can be used to deploy an application.

## Tools to Run K8s

- Minkube; used primarily for people that want to expermient with K8s
- Docker Desktop; a good alternative to minikube although tends to lag behind when introducing new k8 features
- KIND; used to test k8s as part of CI/CD
- Managed Kubernetes Services; most cloud providers have this

## Minikube

```
minikube start

kubectl get nodes

kubectl get all

# create resource from yaml file
kubectl create -f my.yaml
 
# deploy service
kubectl expose deployment helloworld --type=NodePort

# go to service in the browser
minikube service helloworld

# get a deployments configuration
kubectl get deployment/helloworld -o yaml

# get a services configuration
kubectl get service/helloworld -o yaml

```

## Configuration

Config file is within `~/.kube/config`
