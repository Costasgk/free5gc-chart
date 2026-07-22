#!/bin/bash

# 1. Navigate to the free5gc helm chart folder if you aren't already there
cd ~/towards5gs-helm/charts/free5gc

# 2. Update the values.yaml file to use MongoDB 5.0 instead of 6.0
if [ -f values.yaml ]; then
    echo "Updating values.yaml to target MongoDB 5.0..."
    # Uses sed to locate the mongodb tag property and swap it out safely
    sed -i '/mongodb:/,/tag:/s/tag: .*/tag: "5.0"/' values.yaml
else
    echo "Error: values.yaml not found in the current directory."
    exit 1
fi

# 3. Apply the changes to your existing Helm release
echo "Upgrading the free5gc Helm release..."
helm upgrade free5gc-v1 . -n free5gc

# 4. Wait for the statefulset to completely roll out the new image
echo "Waiting for mongodb-0 to become healthy..."
kubectl rollout status statefulset/mongodb -n free5gc --timeout=3m

# 5. Kick the AMF and SMF pods to restore database pipelines cleanly
echo "Restarting core network functions..."
kubectl rollout restart deployment -n free5gc

echo "Database patch complete! Monitor your pods using: kubectl get pods -n free5gc"
