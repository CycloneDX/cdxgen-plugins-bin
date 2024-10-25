#!/usr/bin/env bash

rm -rf plugins/trivy
rm -rf plugins/osquery
rm -rf plugins/dosai
mkdir -p plugins/osquery plugins/dosai

curl -L https://github.com/owasp-dep-scan/dosai/releases/latest/download/Dosai-linux-arm -o plugins/dosai/dosai-linux-arm
chmod +x plugins/dosai/dosai-linux-arm
sha256sum plugins/dosai/dosai-linux-arm > plugins/dosai/dosai-linux-arm.sha256

for plug in trivy
do
    mkdir -p plugins/$plug
    mv ../../plugins/$plug/*linux-arm* plugins/$plug/
    upx -9 --lzma plugins/$plug/*linux-arm* || true
done
