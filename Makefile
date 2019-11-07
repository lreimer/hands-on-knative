NAME = hands-on-knative
VERSION = 1.0.0
GCP = gcloud
ZONE = europe-west1-b
K8S = kubectl

.PHONY: info

info:
	@echo "Hands on Knative"

prepare:
	@$(GCP) config set compute/zone $(ZONE)
	@$(GCP) config set container/use_client_certificate False

cluster:
	@echo "Create GKE Cluster"
	# --[no-]enable-basic-auth --[no-]issue-client-certificate

	@$(GCP) container clusters create $(NAME) --num-nodes=5 --enable-autoscaling --min-nodes=5 --max-nodes=10 --machine-type=n1-standard-4 --enable-stackdriver-kubernetes --enable-ip-alias --enable-autorepair --scopes cloud-platform --addons HorizontalPodAutoscaling,HttpLoadBalancing --cluster-version "1.14"
	@$(K8S) create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$$(gcloud config get-value core/account)
	@$(K8S) cluster-info

helm-install:
	@echo "Install Helm"
	@curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

helm-init:
	@echo "Initialize Helm"

	# add a service account within a namespace to segregate tiller
	@$(K8S) --namespace kube-system create sa tiller

	# create a cluster role binding for tiller
	@$(K8S) create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller

	@helm init --service-account tiller
	@helm repo update

	# verify that helm is installed in the cluster
	@$(K8S) get deploy,svc tiller-deploy -n kube-system

knative-istio:
	@$(K8S) apply --selector knative.dev/crd-install=true --filename https://github.com/knative/serving/releases/download/v0.10.0/serving.yaml --filename https://github.com/knative/eventing/releases/download/v0.10.0/release.yaml --filename https://github.com/knative/serving/releases/download/v0.10.0/monitoring.yaml
	@$(K8S) apply --filename https://github.com/knative/serving/releases/download/v0.10.0/serving.yaml --filename https://github.com/knative/eventing/releases/download/v0.10.0/release.yaml --filename https://github.com/knative/serving/releases/download/v0.10.0/monitoring.yaml
	@$(K8S) apply --filename https://storage.googleapis.com/tekton-releases/pipeline/v0.8.0/release.yaml

	@$(K8S) get pods --namespace knative-serving
	@$(K8S) get pods --namespace knative-eventing
	@$(K8S) get pods --namespace knative-monitoring
	@$(K8S) get pods --namespace tekton-pipelines


knative-ambassador:
	@$(K8S) apply --filename https://github.com/knative/serving/releases/download/v0.10.0/serving-crds.yaml
	@$(K8S) apply --filename https://github.com/knative/serving/releases/download/v0.10.0/serving-core.yaml
	@$(K8S) apply --filename https://getambassador.io/yaml/ambassador/ambassador-knative.yaml --filename https://getambassador.io/yaml/ambassador/ambassador-service.yaml
	@$(K8S) apply --filename https://storage.googleapis.com/tekton-releases/pipeline/v0.8.0/release.yaml

	@$(K8S) get pods --namespace knative-serving
	@$(K8S) get pods --namespace tekton-pipelines

	@$(K8S) get svc ambassador
	@$(K8S) edit cm config-domain --namespace knative-serving

knative-gloo:
	@glooctl install knative --install-knative-version 0.8.0 --install-eventing --install-eventing-version 0.8.0
	@$(K8S) apply --filename https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.8.0/release.yaml

	@$(K8S) get pods --namespace gloo-system
	@$(K8S) get pods --namespace knative-serving
	@$(K8S) get pods --namespace knative-eventing
	@$(K8S) get pods --namespace tekton-pipelines

	@$(K8S) get svc -n gloo-system
	@$(K8S) edit cm config-domain --namespace knative-serving

gcloud-login:
	@$(GCP) auth application-default login

access-token:
	@$(GCP) config config-helper --format=json | jq .credential.access_token

destroy:
	@$(GCP) container clusters delete $(NAME) --async --quiet
