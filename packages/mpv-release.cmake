# Make it fetch latest tarball release since I'm too lazy to manually change it
set(PREFIX_DIR ${CMAKE_CURRENT_BINARY_DIR}/mpv-release-prefix)
file(WRITE ${PREFIX_DIR}/get_latest_tag.sh
"#!/bin/bash
tag=$(curl -sI https://github.com/mpv-player/mpv/releases/latest | grep 'Location' | sed 's#.*/##g' | tr -d '\r')
printf 'https://github.com/mpv-player/mpv/archive/%s.tar.gz' $tag")

# Workaround since cmake dont allow you to change file permission easily
file(COPY ${PREFIX_DIR}/get_latest_tag.sh
     DESTINATION ${PREFIX_DIR}/src
     FILE_PERMISSIONS OWNER_EXECUTE)

execute_process(COMMAND ${PREFIX_DIR}/src/get_latest_tag.sh
                OUTPUT_VARIABLE LINK)

ExternalProject_Add(mpv-release
    DEPENDS
        angle-headers
        ffmpeg
        fribidi
        lcms2
        libarchive
        libass
        libdvdnav
        libdvdread
        libiconv
        libjpeg
        libpng
        luajit
        rubberband
        uchardet
        openal-soft
        mujs
        vulkan
        shaderc
        libplacebo
        spirv-cross
        vapoursynth
    URL ${LINK}
    CONFIGURE_COMMAND ${EXEC}
        PKG_CONFIG=pkg-config
        TARGET=${TARGET_ARCH}
        DEST_OS=win32
        <SOURCE_DIR>/waf configure
        --enable-static-build
        --enable-pdf-build
        --disable-manpage-build
        --enable-libmpv-shared
        --enable-lua
        --enable-javascript
        --enable-libarchive
        --enable-libass
        --enable-libbluray
        --enable-dvdnav
        --enable-uchardet
        --enable-rubberband
        --enable-lcms2
        --enable-openal
        --enable-spirv-cross
        --enable-vulkan
        --enable-vapoursynth
        --prefix=${MINGW_INSTALL_PREFIX}
    BUILD_COMMAND ${EXEC} <SOURCE_DIR>/waf
    INSTALL_COMMAND ""
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(mpv-release bootstrap
    DEPENDEES download
    DEPENDERS configure
    COMMAND <SOURCE_DIR>/bootstrap.py
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)

ExternalProject_Add_Step(mpv-release strip-binary
    DEPENDEES build
    COMMAND ${EXEC} ${TARGET_ARCH}-objcopy --only-keep-debug <SOURCE_DIR>/build/mpv.exe <SOURCE_DIR>/build/mpv.debug
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <SOURCE_DIR>/build/mpv.exe
    COMMAND ${EXEC} ${TARGET_ARCH}-objcopy --add-gnu-debuglink=<SOURCE_DIR>/build/mpv.debug <SOURCE_DIR>/build/mpv.exe
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <SOURCE_DIR>/build/mpv.com
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <SOURCE_DIR>/build/mpv-1.dll
    COMMENT "Stripping mpv binaries"
)

ExternalProject_Add_Step(mpv-release copy-binary
    DEPENDEES strip-binary
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv.exe ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.exe
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv.com ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.com
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/DOCS/man/mpv.pdf ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/doc/manual.pdf

    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv.debug ${CMAKE_CURRENT_BINARY_DIR}/mpv-debug/mpv.debug

    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv-1.dll ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/mpv-1.dll
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv.dll.a ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/libmpv.dll.a
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv.def ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/mpv.def
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/client.h ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/client.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/opengl_cb.h ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/opengl_cb.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/stream_cb.h ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/stream_cb.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/qthelper.hpp ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/qthelper.hpp
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/render.h ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/render.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/render_gl.h ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/render_gl.h

    COMMENT "Copying mpv binaries and manual"
)

set(RENAME ${CMAKE_CURRENT_BINARY_DIR}/mpv-prefix/src/rename.sh)
file(WRITE ${RENAME}
"#!/bin/bash
cd $1
TAG=$(cat VERSION)
mv $2 $2-\${TAG}-$3")

ExternalProject_Add_Step(mpv-release copy-package-dir
    DEPENDEES copy-binary
    COMMAND chmod 755 ${RENAME}
    COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/mpv-package ${CMAKE_BINARY_DIR}/mpv-${TARGET_CPU}-${BUILDDATE}
    COMMAND ${RENAME} <SOURCE_DIR> ${CMAKE_BINARY_DIR}/mpv ${TARGET_CPU}

    COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/mpv-debug ${CMAKE_BINARY_DIR}/mpv-debug-${TARGET_CPU}-${BUILDDATE}
    COMMAND ${RENAME} <SOURCE_DIR> ${CMAKE_BINARY_DIR}/mpv-debug ${TARGET_CPU}

    COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev ${CMAKE_BINARY_DIR}/mpv-dev-${TARGET_CPU}-${BUILDDATE}
    COMMAND ${RENAME} <SOURCE_DIR> ${CMAKE_BINARY_DIR}/mpv-dev ${TARGET_CPU}
    COMMENT "Moving mpv package folder"
    LOG 1
)

extra_step(mpv-release)
