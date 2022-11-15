#!/usr/bin/env bash
rm -rf plugins/goversion
rm -rf plugins/trivy
rm -rf plugins/cargo-auditable
rm -rf plugins/osquery
mkdir -p plugins/osquery

wget https://github.com/osquery/osquery/releases/download/5.6.0/osquery-5.6.0.windows_x86_64.zip
unzip osquery-5.6.0.windows_x86_64.zip
cp "osquery-5.6.0.windows_x86_64/Program Files/osquery/osqueryi.exe" plugins/osquery/osqueryi-windows-amd64.exe
upx -1 plugins/osquery/osqueryi-windows-amd64.exe
sha256sum plugins/osquery/osqueryi-windows-amd64.exe > plugins/osquery/osqueryi-windows-amd64.exe.sha256
rm -rf osquery-5.6.0.windows_x86_64
rm osquery-5.6.0.windows_x86_64.zip

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

./plugins/goversion/goversion-linux-amd64
./plugins/trivy/trivy-cdxgen-linux-amd64 -v
./plugins/cargo-auditable/cargo-auditable-cdxgen-linux-amd64
