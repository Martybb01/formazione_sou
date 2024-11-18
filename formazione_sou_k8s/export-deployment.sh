#!/bin/bash

echo "Exporting deployment..."
TOKEN=$(kubectl -n formazione-sou get secret cluster-reader-token -o jsonpath="{.data.token}" | base64 --decode)
API_SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
CA_CERT=$(kubectl config view --raw -o jsonpath='{.clusters[0].cluster.certificate-authority-data}' | base64 --decode > /home/vagrant/ca.crt)
CERT_FILE="/home/vagrant/ca.crt"
NAMESPACE="formazione-sou"
DEPLOYMENT="flask-app"
OUTFILE="/home/vagrant/deployment.yaml"

echo "Waiting for the deployment to be created..."
kubectl --kubeconfig=/dev/null --token=$TOKEN --server=$API_SERVER --certificate-authority=$CERT_FILE -n $NAMESPACE wait --for=condition=available --timeout=40s deployment/$DEPLOYMENT

if [ $? -ne 0 ]; then
  echo "Deployment not ready, sorry ;("
  exit 1
fi

echo "Deployment is ready, exporting..."
kubectl --kubeconfig=/dev/null --token=$TOKEN --server=$API_SERVER --certificate-authority=$CERT_FILE -n $NAMESPACE get deployment $DEPLOYMENT -o yaml > $OUTFILE

echo "Validating deployment attributes..."

ATTRIBUTES=0

if ! grep -q "readinessProbe" $OUTFILE; then
	echo "Error: readinessProbe not found, sorry ;("
	ATTRIBUTES=1
fi

if ! grep -q "livenessProbe" $OUTFILE; then
	echo "Error: livenessProbe not found, sorry ;("
	ATTRIBUTES=1
fi

if ! grep -q "resources" $OUTFILE; then
	echo "Error: resources not found, sorry ;("
	ATTRIBUTES=1
else
	if ! grep -q "requests" $OUTFILE; then
		echo "Error: requests not found, sorry ;("
		ATTRIBUTES=1
	fi
	if ! grep -q "limits" $OUTFILE; then
		echo "Error: limits not found, sorry ;("
		ATTRIBUTES=1
	fi
fi

if [ $ATTRIBUTES -eq 0 ]; then
	echo "Deployment exported successfully!"
else
	echo "Deployment exported with errors, sorry ;("
	exit 1
fi

exit 0
