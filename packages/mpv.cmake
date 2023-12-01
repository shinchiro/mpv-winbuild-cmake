ExternalProject_Add(mpv
    DEPENDS
        angle-headers
        ffmpeg
        lcms2
        libarchive
        libass
        libdvdnav
        libiconv
        libjpeg
        libbluray
        libplacebo
        libsdl2
        libva
        libzimg
        luajit
        mujs
        nvcodec-headers
        openal-soft
        rubberband
        shaderc
        spirv-cross
        uchardet
        vapoursynth
        vulkan
        vulkan-header
        zlib
    GIT_REPOSITORY https://github.com/mpv-player/mpv.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson <BINARY_DIR> <SOURCE_DIR>
        --cross-file=${MESON_CROSS}
        --default-library=shared
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --prefer-static
        --prefix=${MINGW_INSTALL_PREFIX}
        -Db_lto=true
        -Db_ndebug=true
        -Ddebug=true
        -Doptimization=3
        ${mpv_lto_mode}
        -Dcuda-hwaccel=enabled
        -Dcuda-interop=enabled
        -Dd3d-hwaccel=enabled
        -Dd3d11=enabled
        -Dd3d9-hwaccel=enabled
        -Ddirect3d=enabled
        -Ddvdnav=enabled
        -Ddvdnav=enabled
        -Ddvdnav=enabled
        -Degl-angle-lib=enabled
        -Degl-angle=enabled
        -Degl=enabled
        -Dgl-dxinterop-d3d9=enabled
        -Dgl-dxinterop=enabled
        -Dgl-win32=enabled
        -Dgl=enabled
        -Diconv=enabled
        -Djavascript=enabled
        -Djpeg=enabled
        -Dlcms2=enabled
        -Dlibarchive=enabled
        -Dlibavdevice=enabled
        -Dlibbluray=enabled
        -Dlibmpv=true
        -Dlua=enabled
        -Dopenal=enabled
        -Dpdf-build=enabled
        -Drubberband=enabled
        -Dsdl2-audio=enabled
        -Dsdl2-gamepad=enabled
        -Dsdl2-video=enabled
        -Dsdl2=enabled
        -Dshaderc=enabled
        -Dspirv-cross=enabled
        -Duchardet=enabled
        -Dvaapi-win32=enabled
        -Dvaapi=enabled
        -Dvapoursynth=enabled
        -Dvector=enabled
        -Dvulkan-interop=enabled
        -Dvulkan=enabled
        -Dwasapi=enabled
        -Dwin32-threads=enabled
        -Dzimg=enabled
        -Dzlib=enabled
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(mpv strip-binary
    DEPENDEES build
    ${mpv_add_debuglink}
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <BINARY_DIR>/mpv.exe
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <BINARY_DIR>/mpv.com
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <BINARY_DIR>/libmpv-2.dll
    COMMENT "Stripping mpv binaries"
)

ExternalProject_Add_Step(mpv copy-binary
    DEPENDEES strip-binary
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.exe                           ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.exe
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.com                           ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.com
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.pdf                           ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/doc/manual.pdf
    COMMAND ${CMAKE_COMMAND} -E copy ${MINGW_INSTALL_PREFIX}/etc/fonts/fonts.conf   ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv/fonts.conf
    ${mpv_copy_debug}
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/libmpv-2.dll          ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/libmpv-2.dll
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/libmpv.dll.a          ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/libmpv.dll.a
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/client.h       ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/mpv/client.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/stream_cb.h    ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/mpv/stream_cb.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/render.h       ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/mpv/render.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/render_gl.h    ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/mpv/render_gl.h
    COMMENT "Copying mpv binaries and manual"
)

set(RENAME ${CMAKE_CURRENT_BINARY_DIR}/mpv-prefix/src/rename.sh)
file(WRITE ${RENAME}
"#!/bin/bash
cd $1
GIT=$(git rev-parse --short=7 HEAD)
mv $2 $2-git-\${GIT}")

ExternalProject_Add_Step(mpv copy-package-dir
    DEPENDEES copy-binary
    COMMAND chmod 755 ${RENAME}
    COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/mpv-package ${CMAKE_BINARY_DIR}/mpv-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}
    COMMAND ${RENAME} <SOURCE_DIR> ${CMAKE_BINARY_DIR}/mpv-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}

    COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/mpv-debug ${CMAKE_BINARY_DIR}/mpv-debug-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}
    COMMAND ${RENAME} <SOURCE_DIR> ${CMAKE_BINARY_DIR}/mpv-debug-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}

    COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev ${CMAKE_BINARY_DIR}/mpv-dev-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}
    COMMAND ${RENAME} <SOURCE_DIR> ${CMAKE_BINARY_DIR}/mpv-dev-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}
    COMMENT "Moving mpv package folder"
    LOG 1
)

force_rebuild_git(mpv)
force_meson_configure(mpv)
cleanup(mpv copy-package-dir)
