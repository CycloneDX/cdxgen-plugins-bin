#!/usr/bin/env bash

rm -rf plugins/goversion
rm -rf plugins/trivy
rm -rf plugins/cargo-auditable
rm -rf plugins/osquery
mkdir -p plugins/osquery

wget https://github.com/osquery/osquery/releases/download/5.9.1/osquery-5.9.1.windows_arm64.zip
unzip osquery-5.9.1.windows_arm64.zip
cp "osquery-5.9.1.windows_arm64/Program Files/osquery/osqueryi.exe" plugins/osquery/osqueryi-windows-arm64.exe
sha256sum plugins/osquery/osqueryi-windows-arm64.exe > plugins/osquery/osqueryi-windows-arm64.exe.sha256
rm -rf osquery-5.9.1.windows_arm64
rm osquery-5.9.1.windows_arm64.zip

wget https://github.com/osquery/osquery/releases/download/5.9.1/osquery-5.9.1_1.linux_aarch64.tar.gz
tar -xvf osquery-5.9.1_1.linux_aarch64.tar.gz
cp opt/osquery/bin/osqueryd plugins/osquery/osqueryi-linux-arm64
upx -9 --lzma plugins/osquery/osqueryi-linux-arm64
sha256sum plugins/osquery/osqueryi-linux-arm64 > plugins/osquery/osqueryi-linux-arm64.sha256
rm -rf etc usr var opt
rm osquery-5.9.1_1.linux_aarch64.tar.gz

for plug in goversion trivy cargo-auditable
do
    mkdir -p plugins/$plug
    mv ../../plugins/$plug/*arm64* plugins/$plug/
done
