#!/bin/bash

echo "Exporting deployment..."
TOKEN=$(kubectl -n formazione-sou get secret cluster-reader-token -o jsonpath="{.data.token}" | base64 --decode)
API_SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
CA_CERT=$(kubectl config view --raw -o jsonpath='{.clusters[0].cluster.certificate-authority-data}' | base64 --decode > /home/vagrant/ca.crt)
CERT_FILE="/home/vagrant/ca.crt"
NAMESPACE="formazione-sou"
DEPLOYMENT="flask-app"
OUTFILE="/home/vagrant/deployment.yaml"

kubectl --kubeconfig=/dev/null --token=$TOKEN --server=$API_SERVER --certificate-authority=$CERT_FILE -n $NAMESPACE get deployment $DEPLOYMENT -o yaml > $OUTFILE
