#!/usr/bin/env bash

set -e

rm -rf plugins/trivy

for plug in trivy
do
    mkdir -p plugins/$plug
    mv ../../plugins/$plug/*ppc64* plugins/$plug/
    upx -9 --lzma plugins/$plug/*ppc64* || true
done
