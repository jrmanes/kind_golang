#!/bin/bash
################
PROJECT_NAME=kind_golang
CURRENT_VERSION=$(kubectl get deployment kind-golang -o yaml | grep " image: localhost" | cut -d':' -f4)
TMP_MANIFEST="_tmp"
DEPLOYMENT_MANIFEST_EXT=".yml"
DEPLOYMENT_MANIFEST_NAME="../infra/deployment_blue_green"
DEPLOYMENT_MANIFEST=$DEPLOYMENT_MANIFEST_NAME$DEPLOYMENT_MANIFEST_EXT
DEPLOYMENT_MANIFEST_TMP=$DEPLOYMENT_MANIFEST_NAME$TMP_MANIFEST$DEPLOYMENT_MANIFEST_EXT
RUN=start
################
# will check the current version and change it to the new one
function checkCurrentVersion() {
  if [[ $CURRENT_VERSION == "latest" ]];then
    VERSION=v2
    build_tag_push
    sed "s/VERSION/$VERSION/g" $DEPLOYMENT_MANIFEST > $DEPLOYMENT_MANIFEST_TMP
  else
    VERSION=latest
    sed "s/VERSION/$VERSION/g" $DEPLOYMENT_MANIFEST > $DEPLOYMENT_MANIFEST_TMP
    build_tag_push
  fi
  echo "current version is: $CURRENT_VERSION"
  echo "version is: $VERSION"
}

# build_tag_push will tag the current latest version to the atual version and push it to the registry
function build_tag_push(){
  cd ..
  docker build . -t localhost:5000/${PROJECT_NAME}:$VERSION
  docker push localhost:5000/${PROJECT_NAME}:$VERSION
  cd -
}

# kube_deploy will deploy using the new version
function kube_deploy(){
  kubectl apply -f $DEPLOYMENT_MANIFEST_TMP
}

# clean_files all tmp file
function clean_files(){
  rm $DEPLOYMENT_MANIFEST_TMP
}

# The script starts here
function start() {
  checkCurrentVersion
  kube_deploy
  clean_files
}

# We use our var $RUN in order to call the function start
$RUN