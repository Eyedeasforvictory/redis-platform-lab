#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

echo "Checking Kubernetes cluster..."
kubectl cluster-info

echo "Loading application image into kind..."
kind load docker-image python-api:1.0 --name redis-lab

echo "Deploying Redis..."
kubectl apply -f k8s/redis.yaml

echo "Deploying FastAPI..."
kubectl apply -f k8s/api.yaml

echo "Waiting for Redis..."
kubectl rollout status deployment/redis --timeout=120s

echo "Waiting for FastAPI..."
kubectl rollout status deployment/python-api --timeout=120s

echo "Deployment complete."
kubectl get pods
kubectl get services
