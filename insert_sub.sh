#!/bin/bash
kubectl exec -it mongodb-0 -n free5gc -- mongo 127.0.0.1:27017/free5gc --eval '
db.subscribers.insert({
    "suciProfiles": [],
    "subscribedCcCfProfiles": [],
    "pduSessionContinuityInd": [],
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
    ]
});
'
