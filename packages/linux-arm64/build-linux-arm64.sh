#!/usr/bin/env bash

set -e

rm -rf plugins/trivy
rm -rf plugins/osquery
rm -rf plugins/dosai
rm -rf plugins/sourcekitten
mkdir -p plugins/osquery plugins/dosai plugins/sourcekitten

# Get the linux version built by AppThreat
oras pull ghcr.io/appthreat/cdxgen-plugins-bin:linux-arm64 -o plugins/sourcekitten/
sha256sum plugins/sourcekitten/sourcekitten > plugins/sourcekitten/sourcekitten.sha256

wget https://github.com/osquery/osquery/releases/download/5.16.0/osquery-5.16.0_1.linux_aarch64.tar.gz
tar -xf osquery-5.16.0_1.linux_aarch64.tar.gz
cp opt/osquery/bin/osqueryd plugins/osquery/osqueryi-linux-arm64
upx -9 --lzma plugins/osquery/osqueryi-linux-arm64
sha256sum plugins/osquery/osqueryi-linux-arm64 > plugins/osquery/osqueryi-linux-arm64.sha256
rm -rf etc usr var opt
rm osquery-5.16.0_1.linux_aarch64.tar.gz

curl -L https://github.com/owasp-dep-scan/dosai/releases/latest/download/Dosai-linux-arm64 -o plugins/dosai/dosai-linux-arm64
chmod +x plugins/dosai/dosai-linux-arm64
# check if dosai working
plugins/dosai/dosai-linux-arm64 --help
sha256sum plugins/dosai/dosai-linux-arm64 > plugins/dosai/dosai-linux-arm64.sha256

for plug in trivy
do
    mkdir -p plugins/$plug
    mv ../../plugins/$plug/*linux-arm64* plugins/$plug/
    upx -9 --lzma plugins/$plug/*linux-arm64* || true
done
