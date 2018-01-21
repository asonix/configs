#!/usr/bin/env bash

export RUSTFLAGS='-C target-feature=+crt-static -L native=/usr/i686-w64-mingw32/lib'
export PKG_CONFIG_ALLOW_CROSS=1
cargo build --target i686-pc-windows-gnu
