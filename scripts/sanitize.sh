#!/usr/bin/env bash
# Сборка с ASan + UBSan и запуск программы.
# Аргументы скрипта передаются самой программе.
set -euo pipefail

# Флаги времени выполнения для санитайзеров
export ASAN_OPTIONS="detect_leaks=1:halt_on_error=1:abort_on_error=1"
export UBSAN_OPTIONS="print_stacktrace=1:halt_on_error=1"

echo "==> Building with ASan + UBSan"
make clean
make SANITIZE=1 build

echo "==> Running with sanitizers"
# "$@" — все аргументы, переданные скрипту, уйдут программе
./program "$@"
