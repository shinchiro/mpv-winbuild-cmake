#!/bin/bash
# Automatically build mpv for 32-bit and 64-bit version

mkdir -p ./build32
cd ./build32
cmake -DTARGET_ARCH=i686-w64-mingw32 -G Ninja ..
ninja mpv
cd ..

mkdir -p ./build64
cd ./build64
cmake -DTARGET_ARCH=x86_64-w64-mingw32 -G Ninja ..
ninja mpv
cd ..
