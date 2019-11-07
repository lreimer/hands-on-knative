# Hands on Knative

Demo repository for different Knative showcases for my talk at the Serverless
Computing London conference.

## Installation

### with Istio

```
$ kubectl apply --selector knative.dev/crd-install=true \
   --filename https://github.com/knative/serving/releases/download/v0.10.0/serving.yaml \
   --filename https://github.com/knative/eventing/releases/download/v0.10.0/release.yaml \
   --filename https://github.com/knative/serving/releases/download/v0.10.0/monitoring.yaml

$ kubectl apply --filename https://github.com/knative/serving/releases/download/v0.10.0/serving.yaml \
   --filename https://github.com/knative/eventing/releases/download/v0.10.0/release.yaml \
   --filename https://github.com/knative/serving/releases/download/v0.10.0/monitoring.yaml

$ kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/v0.8.0/release.yaml

$ kubectl get pods --namespace knative-serving
$ kubectl get pods --namespace knative-eventing
$ kubectl get pods --namespace tekton-pipelines
```

### with Ambassador

```
$ kubectl apply --filename https://github.com/knative/serving/releases/download/v0.10.0/serving-crds.yaml
$ kubectl apply --filename https://github.com/knative/serving/releases/download/v0.10.0/serving-core.yaml
$ kubectl apply --filename https://getambassador.io/yaml/ambassador/ambassador-knative.yaml --filename https://getambassador.io/yaml/ambassador/ambassador-service.yaml
$ kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/v0.8.0/release.yaml

$ kubectl get pods --namespace knative-serving
$ kubectl get pods --namespace tekton-pipelines
```

### with Gloo

```
$ glooctl install knative --install-knative-version 0.10.0 --install-eventing --install-eventing-version 0.10.0
$ kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.8.0/release.yaml

$ kubectl get pods --namespace gloo-system
$ kubectl get pods --namespace knative-serving
$ kubectl get pods --namespace knative-eventing
$ kubectl get pods --namespace tekton-pipelines
```

## Tekton Pipelines

```
$ kubectl apply -f tekton/hello-tekton.yaml
$ tkn taskrun describe echo-hello-world-task-run
$ tkn taskrun logs echo-hello-world-task-run

$ kubectl create secret docker-registry regcred \
                    --docker-server=<your-registry-server> \
                    --docker-username=<your-name> \
                    --docker-password=<your-pword> \
                    --docker-email=<your-email>

$ kubectl apply -f tekton/cloud-native-go-resources.yaml
$ kubectl apply -f tekton/cloud-native-go-task.yaml
$ kubectl apply -f tekton/cloud-native-go-taskrun.yaml

$ kubectl create clusterrole deployment-role \
               --verb=get,list,watch,create,update,patch,delete \
               --resource=deployments

$ kubectl create clusterrolebinding deployment-binding \
            --clusterrole=deployment-role \
            --serviceaccount=default:cloud-native-go-service

$ kubectl apply -f tekton/deploy-using-kubectl-task.yaml
$ kubectl apply -f tekton/cloud-native-go-pipeline.yaml
$ kubectl apply -f tekton/cloud-native-go-pipeline-run.yaml

$ tkn pipelinerun logs tutorial-pipeline-run-1 -f
$ tkn pipelinerun describe tutorial-pipeline-run-1
```

## Knative Serving

```
$ kubectl get service -n gloo-system

$ kubectl apply -f serving/helloworld-go.yaml
$ kubectl get ksvc cloud-native-go
$ kubectl get pods

$ http get http://helloworld-go.default.example.com
```

## Knative Eventing

```
$ kubectl apply -f eventing/event-display-service.yaml
$ kubectl apply -f eventing/test-cronjob-source.yaml

$ kubectl logs -l serving.knative.dev/service=event-display -c user-container --since=10m
```

## Maintainer

M.-Leander Reimer (@lreimer), <mario-leander.reimer@qaware.de>

## License

This software is provided under the MIT open source license, read the `LICENSE`
file for details.
