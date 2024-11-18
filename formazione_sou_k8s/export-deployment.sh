#!/bin/bash

echo "Exporting deployment..."
TOKEN=$(kubectl -n formazione-sou get secret cluster-reader-token -o jsonpath="{.data.token}" | base64 --decode)
API_SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
NAMESPACE="formazione-sou"
DEPLOYMENT="flask-app"
OUTFILE="/home/vagrant/deployment.yaml"

kubectl get deployment $DEPLOYMENT -n $NAMESPACE -o yaml --token=$TOKEN --server=$API_SERVER > $OUTFILE

echo "Deployment exported to $OUTFILE"
