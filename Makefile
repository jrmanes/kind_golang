# kind_golang
PROJECT_NAME=kind_golang
PROJECT_NAME_K8S=kind-golang

# Go
run:
	go run cmd/main.go

# Kubernetes
setup_kind:
	./scripts/setup_cluster.sh

delete_kind:
	kind delete cluster

port_forward:
	kubectl port-forward service/${PROJECT_NAME_K8S}-service 8080:8080

kube_deploy:
	kubectl apply -f ./infra

kube_delete:
	kubectl delete -f ./infra

kube_all: docker_all kube_delete kube_deploy

# Docker
build:
	docker build . -t ${PROJECT_NAME}:latest

tag:
	docker tag ${PROJECT_NAME}:latest localhost:5000/${PROJECT_NAME}:latest

push:
	docker push localhost:5000/${PROJECT_NAME}:latest

docker_all: build tag push

