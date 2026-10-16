#!/usr/bin/env bash
# Обычная сборка проекта.
set -euo pipefail

echo "==> Building project (no sanitizers)"
make clean
make build
