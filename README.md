#Sample k8s / Spring boot project

## Build

### Getting started
```
make init
```

### Local build
```
make dist
```

### Docker build
```
make docker-build
```

### Local docker install
```
make docker-install
```

## Local K8s install
* Install docker for mac
    * `brew cask install docker`
* Enable Kubernetes
    * Docker -> Preferenes -> Kubernetes
    * Enable Kubernetes
    * Apply
* Install k8s utils
    * `brew install kubernetes-cli`  *Note: When installing docker for mac's kubernetes a version of `kubectl` is installed.  
                                      You'll have to follow the brew instructions for linking to the correct version.  The docker for mac version is bound to the version of docker.  
                                      This is fine, but you won't be able to upgrade independently.*
    * `brew install kubernetes-helm`    
* Set up helm on your local cluster
    * `helm init`
* Set up ingress
    * `helm upgrade nginx-ingress --install --namespace kube-system stable/nginx-ingress`
* Install application configmap and secrets
    * From the thesus-scribe-secrets project
    * `kubectl apply -f k8s/`
* Build and Tag the application
    * From the thesus-scribe project
    * `docker build -t theseus-scribe .`
    * `docker tag theseus-scribe theseus-scribe:0.0.9`
* Install application
    * From the thesus-scribe project
    * `kubectl apply -f k8s/`
* Verify the application
    * `kubectl get pods`
    * `curl -u"user:pass" http://theseus-scribe.127.0.0.1.xip.io/api/monitor/run_health`    
