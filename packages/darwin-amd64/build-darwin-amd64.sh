#!/usr/bin/env bash

rm -rf plugins/goversion
rm -rf plugins/trivy
rm -rf plugins/cargo-auditable
rm -rf plugins/osquery
rm -rf plugins/dosai
mkdir -p plugins/osquery plugins/dosai

wget https://github.com/osquery/osquery/releases/download/5.11.0/osquery-5.11.0_1.macos_x86_64.tar.gz
tar -xvf osquery-5.11.0_1.macos_x86_64.tar.gz
cp opt/osquery/lib/osquery.app/Contents/MacOS/osqueryd plugins/osquery/osqueryi-darwin-amd64
sha256sum plugins/osquery/osqueryi-darwin-amd64 > plugins/osquery/osqueryi-darwin-amd64.sha256
rm -rf etc usr var opt
rm osquery-5.11.0_1.macos_x86_64.tar.gz

curl -L https://github.com/owasp-dep-scan/dosai/releases/latest/download/Dosai-osx-x64 -o plugins/dosai/dosai-darwin-amd64
chmod +x plugins/dosai/dosai-darwin-amd64
sha256sum plugins/dosai/dosai-darwin-amd64 > plugins/dosai/dosai-darwin-amd64.sha256

for plug in goversion trivy cargo-auditable
do
    mkdir -p plugins/$plug
    mv ../../plugins/$plug/*darwin-amd64* plugins/$plug/
done
