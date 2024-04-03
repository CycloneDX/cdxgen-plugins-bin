#!/usr/bin/env bash

rm -rf plugins/trivy
rm -rf plugins/cargo-auditable

for plug in trivy cargo-auditable
do
    mkdir -p plugins/$plug
    mv ../../plugins/$plug/*ppc64* plugins/$plug/
    upx -9 --lzma plugins/$plug/*ppc64* || true
done
