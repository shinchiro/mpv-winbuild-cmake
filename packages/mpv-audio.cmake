# mpv for the AUDIO_ONLY build (replaces mpv.cmake): only libmpv-2.dll is produced, with
# video output, scripting, hardware decoding and the CLI player turned off.
# `-Dgpl=false` yields an LGPL libmpv because no GPL library is linked into FFmpeg.
# The mpv_* option lists below were checked against meson.options of mpv 0.41.

# libmpv is the only artifact, so no mpv.exe/mpv.debug is involved. With GCC the DLL is
# stripped; with clang/lld no debug info is embedded (-Ddebug=false), so nothing to do.
if(COMPILER_TOOLCHAIN STREQUAL "gcc")
    set(mpv_audio_strip COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <BINARY_DIR>/libmpv-2.dll)
endif()

ExternalProject_Add(mpv
    DEPENDS
        ffmpeg
        fribidi
        libass
        libiconv
        libplacebo
        zlib
    GIT_REPOSITORY https://github.com/mpv-player/mpv.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --default-library=shared
        --prefer-static
        -Ddebug=false
        -Db_ndebug=true
        -Doptimization=3
        -Db_lto=true
        ${mpv_lto_mode}
        -Dgpl=false
        -Dlibmpv=true
        -Dcplayer=false
        -Dbuild-date=false
        -Dtests=false
        -Dpdf-build=disabled
        -Dhtml-build=disabled
        -Dmanpage-build=disabled
        -Dlua=disabled
        -Djavascript=disabled
        -Dcplugins=disabled
        -Dsdl2-gamepad=disabled
        -Dlibarchive=disabled
        -Dlibbluray=disabled
        -Ddvdnav=disabled
        -Ddvda=disabled
        -Dcdda=disabled
        -Ddvbin=disabled
        -Duchardet=disabled
        -Drubberband=disabled
        -Dlcms2=disabled
        -Dzimg=disabled
        -Djpeg=disabled
        -Dvapoursynth=disabled
        -Dsubrandr=disabled
        -Dlibcurl=disabled
        -Dlibavdevice=disabled
        -Dopenal=disabled
        -Dsixel=disabled
        -Dshaderc=disabled
        -Dspirv-cross=disabled
        -Dvulkan=disabled
        -Dd3d11=disabled
        -Ddirect3d=disabled
        -Dgl=disabled
        -Dplain-gl=disabled
        -Degl=disabled
        -Degl-angle=disabled
        -Degl-angle-lib=disabled
        -Degl-angle-win32=disabled
        -Dgl-win32=disabled
        -Dgl-dxinterop=disabled
        -Dgl-dxinterop-d3d9=disabled
        -Dd3d-hwaccel=disabled
        -Dd3d9-hwaccel=disabled
        -Damf=disabled
        -Dcuda-hwaccel=disabled
        -Dcuda-interop=disabled
        -Dvaapi=disabled
        -Dvaapi-win32=disabled
        -Dwin32-smtc=disabled
        -Dc_args='-Wno-error=int-conversion'
    BUILD_COMMAND ${EXEC} LTO_JOB=1 ninja -C <BINARY_DIR>
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(mpv strip-binary
    DEPENDEES build
    ${mpv_audio_strip}
    COMMAND ${CMAKE_COMMAND} -E echo "libmpv-2.dll ready"
    COMMENT "Stripping libmpv"
)

ExternalProject_Add_Step(mpv copy-binary
    DEPENDEES strip-binary
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/mpv
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/libmpv-2.dll          ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/libmpv-2.dll
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/libmpv.dll.a          ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/libmpv.dll.a
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/include/mpv/client.h       ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/mpv/client.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/include/mpv/stream_cb.h    ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/mpv/stream_cb.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/include/mpv/render.h       ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/mpv/render.h
    COMMENT "Copying libmpv"
)

# Name the folder mpv-dev-<cpu>-<date>-git-<hash> (same scheme as upstream) and pack it,
# because mpv-packaging (which would normally do the 7z step) is not part of this build.
set(PACKAGE_AUDIO ${CMAKE_CURRENT_BINARY_DIR}/mpv-prefix/src/package-audio.sh)
file(WRITE ${PACKAGE_AUDIO}
"#!/bin/bash
set -e
cd $1
GIT=$(git rev-parse --short=10 HEAD)
DIR=$2-git-\${GIT}
mv $2 \${DIR}
7z a -m0=lzma2 -mx=9 -ms=on \${DIR}.7z \${DIR}/*")

ExternalProject_Add_Step(mpv package-audio
    DEPENDEES copy-binary
    COMMAND chmod 755 ${PACKAGE_AUDIO}
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_BINARY_DIR}/mpv-dev-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}
    COMMAND ${CMAKE_COMMAND} -E rename ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev ${CMAKE_BINARY_DIR}/mpv-dev-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}
    COMMAND ${PACKAGE_AUDIO} <SOURCE_DIR> ${CMAKE_BINARY_DIR}/mpv-dev-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}
    COMMENT "Packing libmpv"
    LOG 1
)

force_rebuild_git(mpv)
force_meson_configure(mpv)
cleanup(mpv package-audio)
