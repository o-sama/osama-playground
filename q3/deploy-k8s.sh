#!/bin/bash
set -euo pipefail

# Apply Kubernetes configurations
kubectl apply -f k8s/

# Ensure the deployment is successful
kubectl rollout status deployment/bitcoin-core-deployment --timeout=120s