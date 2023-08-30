#!/usr/bin/env bash

rm -rf plugins/goversion
rm -rf plugins/trivy
rm -rf plugins/cargo-auditable
rm -rf plugins/osquery
mkdir -p plugins/osquery

for plug in goversion trivy cargo-auditable
do
    mkdir -p plugins/$plug
    pushd thirdparty/$plug
    make build/linux_ppc64le
    chmod +x build/*
    cp -rf build/* ../../plugins/$plug/
    rm -rf build
    popd
done

./plugins/goversion/goversion-linux-ppc64le
./plugins/trivy/trivy-cdxgen-linux-ppc64le -v
./plugins/cargo-auditable/cargo-auditable-cdxgen-linux-ppc64le

chmod +x packages/ppc64/build-ppc64.sh
pushd packages/ppc64
./build-ppc64.sh
popd

