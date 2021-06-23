# Kind Golang

The following repository is a project structure which will deploy an application written in Golang to a kubernetes cluster using technologies such us Kubernetes, Docker, Kind, Golang, Shell Sript.

---

## Kind installation
```shell
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
mv ./kind /usr/local/bin/kind
```
---

## Setup

You can use the Makefile to make your development tasks easy.

---

## Tools needed
- Kubectl: https://kubernetes.io/docs/reference/kubectl/kubectl/
- Kind: https://kind.sigs.k8s.io/docs/
- Docker: https://www.docker.com/
- Golang: https://golang.org/

---

Jose Ramón Mañes