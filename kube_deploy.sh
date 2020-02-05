#!/bin/bash

set -uxo pipefail

which helmi
rc=$?

if [ $rc -eq 0 ]
then
    echo "Using Helm to Deploy"
    helm install --generate-name ./javacert
else
    echo "Deploying Using Manifest files"
    kubectl apply -f manifests/namespace.yaml
    sleep 5
    kubectl apply -f manifests/
fi
