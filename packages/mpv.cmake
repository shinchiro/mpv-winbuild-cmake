get_property(src_luajit TARGET luajit PROPERTY _EP_SOURCE_DIR)
get_property(src_luajit_wrap TARGET luajit-wrap PROPERTY _EP_SOURCE_DIR)
ExternalProject_Add(mpv
    DEPENDS
        angle-headers
        nvcodec-headers
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
        libsixel
    GIT_REPOSITORY https://github.com/mpv-player/mpv.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --filter=tree:0"
    GIT_PROGRESS TRUE
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${src_luajit} <SOURCE_DIR>/subprojects/luajit
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${src_luajit_wrap}/subprojects/packagefiles/luajit <SOURCE_DIR>/subprojects/luajit
    COMMAND ${EXEC} CONF=1 meson setup --reconfigure <BINARY_DIR> <SOURCE_DIR>
        ${meson_conf_args}
        --force-fallback-for=luajit
        --prefer-static
        -Db_lto=true
        -Db_lto_mode=thin
        -Dlibmpv=false
        -Dcplayer=true
        -Dpdf-build=enabled
        -Dlua=luajit
        -Dluajit:amalgam=true
        -Dluajit:lua52compat=true
        -Dluajit:sysmalloc=true
        -Dluajit:luajit=false
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
        -Dvapoursynth=enabled
        -Dsixel=enabled
        -Dgl=enabled
        -Degl-angle=enabled
    COMMAND ${EXEC} CONF=1 meson setup --reconfigure <BINARY_DIR>/libmpv <SOURCE_DIR>
        ${meson_conf_args}
        --force-fallback-for=luajit
        --default-library=shared
        --prefer-static
        -Db_lto=true
        -Db_lto_mode=thin
        -Dlibmpv=true
        -Dcplayer=false
        -Dmanpage-build=disabled
        -Dlua=luajit
        -Dluajit:amalgam=true
        -Dluajit:lua52compat=true
        -Dluajit:sysmalloc=true
        -Dluajit:luajit=false
        -Dluajit:default_library=static
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
        -Dvapoursynth=enabled
        -Dsixel=enabled
        -Dgl=enabled
        -Degl-angle=enabled
    BUILD_COMMAND ${EXEC} PDB=1 HIDE=1 ninja -C <BINARY_DIR>
          COMMAND ${EXEC} PDB=1 ninja -C <BINARY_DIR>/libmpv
    INSTALL_COMMAND ${EXEC} PDB=1 meson install -C <BINARY_DIR>/libmpv --only-changed --tags devel
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(mpv copy-binary
    DEPENDEES install
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.exe             ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.exe
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.com             ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.com
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.pdb             ${CMAKE_CURRENT_BINARY_DIR}/mpv-debug/mpv.pdb
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.pdf             ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/doc/manual.pdf
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/libmpv/libmpv-2.pdb ${CMAKE_CURRENT_BINARY_DIR}/mpv-debug/libmpv-2.pdb
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/libmpv/libmpv-2.dll ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/libmpv-2.dll
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/libmpv/libmpv.dll.a ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/libmpv.dll.a
    COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/include   ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include
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
cleanup(mpv copy-package-dir)
