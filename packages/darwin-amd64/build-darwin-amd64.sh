#!/usr/bin/env bash

rm -rf plugins/trivy
rm -rf plugins/osquery
rm -rf plugins/dosai
rm -rf plugins/sourcekitten
mkdir -p plugins/osquery plugins/dosai plugins/sourcekitten

oras pull ghcr.io/cyclonedx/cdxgen-plugins-bin:darwin-amd64 -o plugins/sourcekitten/

curl -L https://github.com/owasp-dep-scan/dosai/releases/latest/download/Dosai-osx-x64 -o plugins/dosai/dosai-darwin-amd64
chmod +x plugins/dosai/dosai-darwin-amd64
# check if dosai working
plugins/dosai/dosai-darwin-amd64 --help
sha256sum plugins/dosai/dosai-darwin-amd64 > plugins/dosai/dosai-darwin-amd64.sha256

for plug in trivy
do
    mkdir -p plugins/$plug
    mv ../../plugins/$plug/*darwin-amd64* plugins/$plug/
done

