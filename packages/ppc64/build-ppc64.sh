#!/usr/bin/env bash

rm -rf plugins/goversion
rm -rf plugins/trivy
rm -rf plugins/cargo-auditable

for plug in goversion trivy cargo-auditable
do
    mkdir -p plugins/$plug
    mv ../../plugins/$plug/*ppc64* plugins/$plug/
done
