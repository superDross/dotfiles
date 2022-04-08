
Starting minikube now needs this as cgroup works best with systemd on linux:

```
minikube start --vm-driver=none --extra-config=kubelet.cgroup-driver=systemd
```

```
# USING OUR SUPPORT VERSION
# deploy nginx example to local minikube cluster (ensure minikube is the current context)
helm upgrade \
  --install \
  --values hello.yml \
  hello \
  support/ygapp
```

expose port 

```
# expose port 8989
kubectl port-forward service/hello-app 8989:80 
```

```
# using minikube
minikub service hello-app
```

```
helm upgrade --install --values chart/us2_staging_values.yaml --set version=14.0 --set image.tag=14.0 airportlocker-local chart
 ```

viewing multiple k8s logs at once

```
stern airportlocker
```

Jump into a bash shell:

```
kubectl exec --stdin --tty shell-demo -- /bin/bash
```

## minikube 

### adding image to minikube docker

```sh
eval $(minikube docker-env)
docker build -t airportlocker-fun .
```

### get mongo working in cluster

```
docker run blah blah mongo (google it)
kubectl run mongo --image=mongo:latest --port=27017
```

### Run mongo

```
kubectl run mongo --image=mongo:latest --port=27017

kubectl port-forward pods/mongo 27017:27017
```


### Pushing images to minikubes docker

Only relevant on minikube using docker vm

```
docker build ...
minikube cache add image-name:version
```


#### Get pods for a specific node

```
kubectl -n devops --context ldc2 get pods -o wide --field-selector spec.nodeName=k33
```


#### Scale replicas to 0

```
kubectl -n g --context ldc2 scale deploy ivwbot-production-app --replicas=0
```

### Delete 

When seeing this error:

```
Error: UPGRADE FAILED: "app" has no deployed releases
```

Do this to recover

```
# find the app helm release
helm list --kube-context ldc2 -n g | grep app
# delete it
helm delete -n g --kube-context ldc2 app-ivw-ldc2-staging
```

Retry the deployment
