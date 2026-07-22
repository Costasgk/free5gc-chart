#!/bin/bash

# 1. Clean out the subscriber table completely for this IMSI and add it cleanly
kubectl exec -it mongodb-0 -n free5gc -- mongo 127.0.0.1:27017/free5gc --eval '
db.subscribers.remove({"ueId": "imsi-208930000000003"});
db.subscribers.insert({
    "ueId": "imsi-208930000000003",
    "opc": "8e27b6af0e692e750f32667a3b14605d",
    "key": "8baf473f2f8fd09487cccbd7097c6862",
    "sequenceNumber": "000000000000",
    "amf": "8000",
    "op": "",
    "opType": "OPC",
    "sliceList": [
        {
            "sst": 1,
            "sd": "010203",
            "defaultType": true
        }
    ],
    "security": {
        "k": "8baf473f2f8fd09487cccbd7097c6862",
        "opc": "8e27b6af0e692e750f32667a3b14605d",
        "amf": "8000",
        "sqn": "000000000000",
        "op": "",
        "opType": "OPC"
    }
});
'

# 2. Hard-restart the structural AMF deployment to completely clear out runtime memory cache
echo "Clearing AMF state..."
kubectl rollout restart deployment/free5gc-v1-free5gc-amf-amf -n free5gc

echo "Waiting for the new AMF pod to initialize..."
kubectl rollout status deployment/free5gc-v1-free5gc-amf-amf -n free5gc --timeout=2m
