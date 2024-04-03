#!/usr/bin/env bash

rm -rf plugins/trivy
rm -rf plugins/cargo-auditable
rm -rf plugins/osquery
rm -rf plugins/dosai
mkdir -p plugins/osquery plugins/dosai

curl -L https://github.com/owasp-dep-scan/dosai/releases/latest/download/Dosai-osx-arm64 -o plugins/dosai/dosai-darwin-arm64
chmod +x plugins/dosai/dosai-darwin-arm64
sha256sum plugins/dosai/dosai-darwin-arm64 > plugins/dosai/dosai-darwin-arm64.sha256

for plug in trivy cargo-auditable
do
    mkdir -p plugins/$plug
    mv ../../plugins/$plug/*darwin-arm64* plugins/$plug/
done
