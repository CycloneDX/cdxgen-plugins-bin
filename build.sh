#!/usr/bin/env bash

rm -rf plugins/trivy
rm -rf plugins/osquery
rm -rf plugins/dosai
rm -rf plugins/sourcekitten
mkdir -p plugins/osquery plugins/dosai plugins/sourcekitten

oras pull ghcr.io/cyclonedx/cdxgen-plugins-bin:linux-amd64 -o plugins/sourcekitten/
sha256sum plugins/sourcekitten/sourcekitten > plugins/sourcekitten/sourcekitten.sha256

wget https://github.com/osquery/osquery/releases/download/5.13.1/osquery-5.13.1_1.linux_x86_64.tar.gz
tar -xvf osquery-5.13.1_1.linux_x86_64.tar.gz
cp opt/osquery/bin/osqueryd plugins/osquery/osqueryi-linux-amd64
upx -9 --lzma plugins/osquery/osqueryi-linux-amd64
sha256sum plugins/osquery/osqueryi-linux-amd64 > plugins/osquery/osqueryi-linux-amd64.sha256
rm -rf etc usr var opt
rm osquery-5.13.1_1.linux_x86_64.tar.gz

curl -L https://github.com/owasp-dep-scan/dosai/releases/latest/download/Dosai -o plugins/dosai/dosai-linux-amd64
chmod +x plugins/dosai/dosai-linux-amd64
sha256sum plugins/dosai/dosai-linux-amd64 > plugins/dosai/dosai-linux-amd64.sha256

for plug in trivy
do
    mkdir -p plugins/$plug
    pushd thirdparty/$plug
    make all
    chmod +x build/*
    cp -rf build/* ../../plugins/$plug/
    rm -rf build
    popd
done

./plugins/osquery/osqueryi-linux-amd64 --help
upx -9 --lzma ./plugins/trivy/trivy-cdxgen-linux-amd64
./plugins/trivy/trivy-cdxgen-linux-amd64 -v
./plugins/dosai/dosai-linux-amd64 --help

for flavours in windows-amd64 linux-arm64 linux-arm windows-arm64 darwin-arm64 darwin-amd64 ppc64
do
    chmod +x packages/$flavours/build-$flavours.sh
    pushd packages/$flavours
    ./build-$flavours.sh
    popd
done
