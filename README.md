# Hands on Knative

Demo repository for different Knative showcases for my talk at the Serverless
Computing London conference.

## Tekton Pipelines

kubectl apply -f tekton/hello-tekton.yaml
tkn taskrun describe echo-hello-world-task-run
tkn taskrun logs echo-hello-world-task-run

kubectl create secret docker-registry regcred \
                    --docker-server=<your-registry-server> \
                    --docker-username=<your-name> \
                    --docker-password=<your-pword> \
                    --docker-email=<your-email>

kubectl apply -f tekton/cloud-native-go-resources.yaml
kubectl apply -f tekton/cloud-native-go-task.yaml
kubectl apply -f tekton/cloud-native-go-taskrun.yaml

kubectl create clusterrole deployment-role \
               --verb=get,list,watch,create,update,patch,delete \
               --resource=deployments

kubectl create clusterrolebinding deployment-binding \
            --clusterrole=deployment-role \
            --serviceaccount=default:cloud-native-go-service

kubectl apply -f tekton/deploy-using-kubectl-task.yaml
kubectl apply -f tekton/cloud-native-go-pipeline.yaml
kubectl apply -f tekton/cloud-native-go-pipeline-run.yaml

tkn pipelinerun logs tutorial-pipeline-run-1 -f
tkn pipelinerun describe tutorial-pipeline-run-1

## Knative Serving

kubectl get service -n gloo-system

kubectl apply -f serving/helloworld-go.yaml
kubectl get ksvc cloud-native-go
kubectl get pods

http get http://helloworld-go.default.example.com

## Knative Eventing

kubectl apply -f eventing/event-display-service.yaml
kubectl apply -f eventing/test-cronjob-source.yaml

kubectl logs -l serving.knative.dev/service=event-display -c user-container --since=10m

## Maintainer

M.-Leander Reimer (@lreimer), <mario-leander.reimer@qaware.de>

## License

This software is provided under the MIT open source license, read the `LICENSE`
file for details.
