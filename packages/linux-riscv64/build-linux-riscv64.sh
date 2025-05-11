#!/usr/bin/env bash

set -e

rm -rf plugins/trivy

for plug in trivy
do
    mkdir -p plugins/$plug
    mv ../../plugins/$plug/*linux-riscv64* plugins/$plug/
    upx -9 --lzma plugins/$plug/*linux-riscv64* || true
done
