# Hands on Knative

Demo repository for different Knative showcases for my talk at the Serverless
Computing London conference.

## Tekton Pipelines

kubectl apply -f hello-tekton.yaml
tkn taskrun describe echo-hello-world-task-run
tkn taskrun logs echo-hello-world-task-run

kubectl apply -f cloud-native-go-resources.yaml
kubectl apply -f cloud-native-go-task.yaml
kubectl apply -f cloud-native-go-taskrun.yaml

kubectl create secret docker-registry regcred \
                    --docker-server=<your-registry-server> \
                    --docker-username=<your-name> \
                    --docker-password=<your-pword> \
                    --docker-email=<your-email>

kubectl create clusterrole deployment-role \
               --verb=get,list,watch,create,update,patch,delete \
               --resource=deployments

kubectl create clusterrolebinding deployment-binding \
            --clusterrole=deployment-role \
            --serviceaccount=default:cloud-native-go-service

kubectl apply -f deploy-using-kubectl-task.yaml
kubectl apply -f cloud-native-go-pipeline.yaml
kubectl apply -f cloud-native-go-pipeline-run.yaml

tkn pipelinerun logs tutorial-pipeline-run-1 -f
tkn pipelinerun describe tutorial-pipeline-run-1

## Knative Serving

kubectl apply -f helloworld-go.yaml

kubectl get service -n gloo-system
http get http://helloworld-go.default.example.com

## Knative Eventing


## Maintainer

M.-Leander Reimer (@lreimer), <mario-leander.reimer@qaware.de>

## License

This software is provided under the MIT open source license, read the `LICENSE`
file for details.
