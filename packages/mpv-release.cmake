# Make it fetch latest tarball release since I'm too lazy to manually change it
set(PREFIX_DIR ${CMAKE_CURRENT_BINARY_DIR}/mpv-release-prefix)
file(WRITE ${PREFIX_DIR}/get_latest_tag.sh
"#!/bin/bash
tag=$(curl -sI https://github.com/mpv-player/mpv/releases/latest | grep 'location: https://github.com/mpv-player/mpv/releases' | sed 's#.*/##g' | tr -d '\r')
printf 'https://github.com/mpv-player/mpv/archive/%s.tar.gz' $tag")

# Workaround since cmake dont allow you to change file permission easily
file(COPY ${PREFIX_DIR}/get_latest_tag.sh
     DESTINATION ${PREFIX_DIR}/src
     FILE_PERMISSIONS OWNER_EXECUTE OWNER_READ)

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
        libsdl2
    URL ${LINK}
    SOURCE_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ${EXEC} meson <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --buildtype=release
        --default-library=shared
        --prefer-static
        -Db_lto=true
        ${mpv_lto_mode}
        -Db_ndebug=true
        -Dlibmpv=true
        -Dpdf-build=enabled
        -Dlua=enabled
        -Djavascript=enabled
        -Dsdl2=enabled
        -Dlibarchive=enabled
        -Dlibbluray=enabled
        -Ddvdnav=enabled
        -Duchardet=enabled
        -Drubberband=enabled
        -Dlcms2=enabled
        -Dopenal=enabled
        -Dspirv-cross=enabled
        -Dvulkan=enabled
        -Dlibplacebo=enabled
        -Dvapoursynth=enabled
        -Degl-angle=enabled
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(mpv-release copy-versionfile
    DEPENDEES download
    DEPENDERS configure
    COMMAND bash -c "cp VERSION <INSTALL_DIR>/VERSION"
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)

ExternalProject_Add_Step(mpv-release strip-binary
    DEPENDEES build
    COMMAND ${EXEC} ${TARGET_ARCH}-objcopy --only-keep-debug <BINARY_DIR>/mpv.exe <BINARY_DIR>/mpv.debug
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <BINARY_DIR>/mpv.exe
    COMMAND ${EXEC} ${TARGET_ARCH}-objcopy --add-gnu-debuglink=<BINARY_DIR>/mpv.debug <BINARY_DIR>/mpv.exe
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <BINARY_DIR>/generated/mpv.com
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <BINARY_DIR>/libmpv-2.dll
    COMMENT "Stripping mpv binaries"
)

ExternalProject_Add_Step(mpv-release copy-binary
    DEPENDEES strip-binary
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.exe                           ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.exe
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/generated/mpv.com                 ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.com
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.pdf                           ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/doc/manual.pdf
    COMMAND ${CMAKE_COMMAND} -E copy ${MINGW_INSTALL_PREFIX}/etc/fonts/fonts.conf   ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv/fonts.conf
    COMMENT "Copying mpv binaries and manual"
)

set(RENAME ${CMAKE_CURRENT_BINARY_DIR}/mpv-prefix/src/rename-stable.sh)
file(WRITE ${RENAME}
"#!/bin/bash
cd $1
TAG=$(cat VERSION)
mv $2 $3/mpv-\${TAG}-$4")

ExternalProject_Add_Step(mpv-release copy-package-dir
    DEPENDEES copy-binary
    COMMAND chmod 755 ${RENAME}
    COMMAND ${RENAME} <SOURCE_DIR> ${CMAKE_CURRENT_BINARY_DIR}/mpv-package ${CMAKE_BINARY_DIR} ${TARGET_CPU}${x86_64_LEVEL}
    COMMENT "Moving mpv package folder"
    LOG 1
)

cleanup(mpv-release copy-package-dir)
