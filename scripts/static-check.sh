#!/usr/bin/env bash
# Статические проверки: clang + cppcheck.
set -euo pipefail

echo "==> Static analysis"
make check
