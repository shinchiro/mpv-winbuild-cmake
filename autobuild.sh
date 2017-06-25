#!/bin/bash
# Automatically build mpv for 32-bit and 64-bit version

mkdir -p ./build32
cd ./build32
cmake -DTARGET_ARCH=i686-w64-mingw32 -G Ninja ..
ninja mpv
cd ..

if [ -d ./build32/mpv-i686* ] ; then
    echo "Successfully compiled 32-bit. Continue"
else
    echo "Failed compiled 32-bit. Stop"
    exit
fi

mkdir -p ./build64
cd ./build64
cmake -DTARGET_ARCH=x86_64-w64-mingw32 -G Ninja ..
ninja mpv
cd ..

mkdir -p ./release
cd ./release
mv ../build32/mpv-* ./ && mv ../build64/mpv-* ./
wget --continue -O mpv-packaging.zip https://github.com/shinchiro/mpv-packaging/archive/master.zip
unzip mpv-packaging.zip
cd ./mpv-packaging-master
7z x -y ./d3dcompiler*.7z
cp -r ./mpv-root/* ./x64/d3dcompiler_43.dll ../mpv-x86_64*
cp -r ./mpv-root/* ./x86/d3dcompiler_43.dll ../mpv-i686*
cd ..
rm -rf ./mpv-packaging-master
for dir in ./*; do
    if [ -d $dir ]; then
        7z a -m0=lzma2 -mx=9 -ms=on $dir.7z $dir/*
        rm -rf $dir
    fi
done
cd ..
