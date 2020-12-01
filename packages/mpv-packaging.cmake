set(PACKAGE ${CMAKE_CURRENT_BINARY_DIR}/mpv-packaging-prefix/src/packaging.sh)
file(WRITE ${PACKAGE}
"#!/bin/bash
7z x -y $1/d3dcompiler*.7z
for dir in $2/mpv*$3*; do
if [ -d $dir ] && [[ $dir =~ mpv-$3.*-git-* ]]; then
    cp -r $1/mpv-root/* $1/$3/d3dcompiler_43.dll $dir
    7z a -m0=lzma2 -mx=9 -ms=on $dir.7z $dir/* -x!*.7z
elif [ -d $dir ] && [[ $dir =~ mpv-.*$3$ ]]; then
    cp -r $1/mpv-root/mpv $1/mpv-root/fonts $1/$3/d3dcompiler_43.dll $dir
    7z a -m0=lzma2 -mx=9 -ms=on $dir.7z $dir/* -x!*.7z
elif [ -d $dir ]; then
    7z a -m0=lzma2 -mx=9 -ms=on $dir.7z $dir/* -x!*.7z
fi
done")

ExternalProject_Add(mpv-packaging
    GIT_REPOSITORY https://github.com/shinchiro/mpv-packaging.git
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    COMMAND chmod 755 ${PACKAGE}
    COMMAND ${PACKAGE} <SOURCE_DIR> ${CMAKE_BINARY_DIR} ${TARGET_CPU}
    BUILD_IN_SOURCE 1
)

extra_step(mpv-packaging)
