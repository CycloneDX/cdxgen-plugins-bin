#!/usr/bin/env bash
rm -rf plugins/goversion
rm -rf plugins/trivy
rm -rf plugins/cargo-auditable

for plug in goversion trivy cargo-auditable
do
    mkdir -p plugins/$plug
    pushd thirdparty/$plug
    make all
    chmod +x build/*
    cp -rf build/* ../../plugins/$plug/
    rm -rf build
    popd
done
