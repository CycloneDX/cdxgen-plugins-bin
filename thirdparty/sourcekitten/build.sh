#!/usr/bin/env bash

pushd .
cd thirdparty/sourcekitten
rm -rf SourceKitten
git clone "https://github.com/jpsim/SourceKitten.git" --depth=1
cd SourceKitten
swift build -c release
chmod +x .build/release/sourcekitten
./.build/release/sourcekitten --help
shasum -a 256 .build/release/sourcekitten > .build/release/sourcekitten.sha256 || true
popd
