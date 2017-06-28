#!/bin/bash
# Automatically build mpv for 32-bit and 64-bit version

main() {
    prepare
    if [ "$1" == "32" ]; then
        package "32" "i686"
    elif [ "$1" == "64" ]; then
        package "64" "x86_64"
    else [ "$1" == "all" ];
        package "32" "i686"
        package "64" "x86_64"
    fi
    rm -rf ./release/mpv-packaging-master
}

package() {
    local bit=$1
    local arch=$2

    build $bit $arch
    zip $bit $arch
}

build() {
    local bit=$1
    local arch=$2
    mkdir -p ./build$bit
    cd ./build$bit
    cmake -DTARGET_ARCH=$arch-w64-mingw32 -G Ninja ..
    ninja clean
    ninja mpv
    cd ..

    if [ -d ./build$bit/mpv-$arch* ] ; then
        echo "Successfully compiled $bit-bit. Continue"
    else
        echo "Failed compiled $bit-bit. Stop"
        exit
    fi
}

zip() {
    local bit=$1
    local arch=$2

    mv ./build$bit/mpv-* ./release
    cd ./release/mpv-packaging-master
    cp -r ./mpv-root/* ./$arch/d3dcompiler_43.dll ../mpv-$arch*
    cd ..
    for dir in ./mpv*$arch*; do
        if [ -d $dir ]; then
            7z a -m0=lzma2 -mx=9 -ms=on $dir.7z $dir/*
            rm -rf $dir
        fi
    done
    cd ..
}

prepare() {
    mkdir -p ./release
    cd ./release
    wget --continue -O mpv-packaging.zip https://github.com/shinchiro/mpv-packaging/archive/master.zip
    unzip mpv-packaging.zip
    cd ./mpv-packaging-master
    7z x -y ./d3dcompiler*.7z
    cd ../..
}

main $1
