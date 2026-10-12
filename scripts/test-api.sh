#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://localhost:8002}"

echo "Testing home endpoint..."
curl --fail --silent --show-error "$BASE_URL/"
echo

echo "Testing readiness endpoint..."
curl --fail --silent --show-error "$BASE_URL/ready"
echo

echo "Testing Redis-backed storage..."
curl --fail --silent --show-error \
  -X POST "$BASE_URL/cache?key=automation&value=works"
echo

echo "Testing retrieval..."
curl --fail --silent --show-error \
  "$BASE_URL/cache?key=automation"
echo

echo "All API tests passed."
