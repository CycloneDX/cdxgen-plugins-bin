#!/usr/bin/env bash

pushd .
cd thirdparty/sourcekitten
rm -rf SourceKitten
git clone "https://github.com/jpsim/SourceKitten.git" --depth=1
cd SourceKitten
swift build -c release
sha256sum .build/release/sourcekitten > .build/release/sourcekitten.sha256
popd
