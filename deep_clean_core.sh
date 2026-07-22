#!/bin/bash

echo "=== Scaling down control plane deployments ==="
kubectl scale deployment/free5gc-v1-free5gc-amf-amf --replicas=0 -n free5gc
kubectl scale deployment/free5gc-v1-free5gc-ausf-ausf --replicas=0 -n free5gc
kubectl scale deployment/free5gc-v1-free5gc-udm-udm --replicas=0 -n free5gc
kubectl scale deployment/free5gc-v1-free5gc-nrf-nrf --replicas=0 -n free5gc

echo "Waiting for pods to fully terminate..."
sleep 10

echo "=== Bootstrapping Service Discovery Base (NRF) ==="
kubectl scale deployment/free5gc-v1-free5gc-nrf-nrf --replicas=1 -n free5gc
kubectl rollout status deployment/free5gc-v1-free5gc-nrf-nrf -n free5gc --timeout=1m

echo "Giving NRF 10 seconds to stabilize its SBI listener..."
sleep 10

echo "=== Bootstrapping Backend Security Elements (AUSF & UDM) ==="
kubectl scale deployment/free5gc-v1-free5gc-ausf-ausf --replicas=1 -n free5gc
kubectl scale deployment/free5gc-v1-free5gc-udm-udm --replicas=1 -n free5gc
kubectl rollout status deployment/free5gc-v1-free5gc-ausf-ausf -n free5gc --timeout=1m
kubectl rollout status deployment/free5gc-v1-free5gc-udm-udm -n free5gc --timeout=1m

echo "=== Bootstrapping Core Access Engine (AMF) ==="
kubectl scale deployment/free5gc-v1-free5gc-amf-amf --replicas=1 -n free5gc
kubectl rollout status deployment/free5gc-v1-free5gc-amf-amf -n free5gc --timeout=1m

echo "=== Verification ==="
kubectl get pods -n free5gc
