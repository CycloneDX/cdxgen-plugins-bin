#!/usr/bin/env bash
set -e  # Exit on error

# Remove old plugin directories to ensure a clean build
rm -rf plugins/trivy plugins/osquery plugins/sourcekitten plugins/dosai
mkdir -p plugins/trivy plugins/osquery plugins/sourcekitten plugins/dosai

# Download the Dosai binary
curl -L https://github.com/owasp-dep-scan/dosai/releases/latest/download/Dosai-linux-amd64 -o plugins/dosai/dosai-linux-amd64
chmod +x plugins/dosai/dosai-linux-amd64
sha256sum plugins/dosai/dosai-linux-amd64 > plugins/dosai/dosai-linux-amd64.sha256

# Copy sourcekitten
mv ../../plugins/sourcekitten/* plugins/sourcekitten/

for plug in trivy osquery; do
    mkdir -p plugins/$plug
    if [ -d "../../plugins/$plug" ] && [ "$(ls -A ../../plugins/$plug/*linux-amd64* 2>/dev/null)" ]; then
        mv ../../plugins/$plug/*linux-amd64* plugins/$plug/
        upx -9 --lzma plugins/$plug/*linux-amd64* || true
    else
        echo "Warning: No files found for $plug in ../../plugins/$plug/"
    fi
done
