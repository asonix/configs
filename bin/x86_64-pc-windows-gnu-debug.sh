#!/usr/bin/env bash

export RUSTFLAGS='-C target-feature=+crt-static -L native=/usr/x86_64-w64-mingw32/lib'
export PKG_CONFIG_ALLOW_CROSS=1
cargo build --target x86_64-pc-windows-gnu
