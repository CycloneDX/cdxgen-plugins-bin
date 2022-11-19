#!/usr/bin/env bash
rm -rf plugins/goversion
rm -rf plugins/trivy
rm -rf plugins/cargo-auditable
rm -rf plugins/osquery
mkdir -p plugins/osquery

wget https://github.com/osquery/osquery/releases/download/5.6.0/osquery-5.6.0_1.linux_x86_64.tar.gz
tar -xvf osquery-5.6.0_1.linux_x86_64.tar.gz
cp opt/osquery/bin/osqueryd plugins/osquery/osqueryi-linux-amd64
upx -1 plugins/osquery/osqueryi-linux-amd64
sha256sum plugins/osquery/osqueryi-linux-amd64 > plugins/osquery/osqueryi-linux-amd64.sha256
rm -rf etc usr var opt
rm osquery-5.6.0_1.linux_x86_64.tar.gz

for plug in goversion trivy cargo-auditable
do
    mkdir -p plugins/$plug
    pushd thirdparty/$plug
    make linux
    chmod +x build/*
    cp -rf build/* ../../plugins/$plug/
    rm -rf build
    popd
done

./plugins/osquery/osqueryi-linux-amd64 --help
./plugins/goversion/goversion-linux-amd64
./plugins/trivy/trivy-cdxgen-linux-amd64 -v
./plugins/cargo-auditable/cargo-auditable-cdxgen-linux-amd64
