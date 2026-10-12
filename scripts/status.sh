#!/usr/bin/env bash
set -euo pipefail

echo "=== Nodes ==="
kubectl get nodes

echo
echo "=== Pods ==="
kubectl get pods -o wide

echo
echo "=== Services ==="
kubectl get services

echo
echo "=== Recent events ==="
kubectl get events --sort-by=.metadata.creationTimestamp
