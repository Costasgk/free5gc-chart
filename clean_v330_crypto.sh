#!/bin/bash

kubectl exec -it mongodb-0 -n free5gc -- mongo 127.0.0.1:27017/free5gc --eval '
const supi = "imsi-208930000000003";

// 1. Permanently remove the problematic document
db["subscriptionData.authenticationData.authenticationSubscription"].remove({"ueId": supi});

// 2. Insert a pristine document with only the explicit OPC property
db["subscriptionData.authenticationData.authenticationSubscription"].insert({
    "ueId": supi,
    "authenticationMethod": "5G_AKA",
    "permanentKey": {
        "encryptionKey": 0,
        "permanentKeyValue": "8baf473f2f8fd09487cccbd7097c6862"
    },
    "sequenceNumber": {
        "sqn": "000000000000",
        "sqnScheme": "NON_TIME_BASED",
        "ind": 0
    },
    "authenticationManagementField": "8000",
    "opc": {
        "encryptionKey": 0,
        "opcValue": "8e27b6af0e692e750f32667a3b14605d"
    }
});

print("=== Pristine OPC Document Injected Successfully ===");
'
