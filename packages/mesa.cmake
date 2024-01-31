ExternalProject_Add(mesa
    DEPENDS
        libva
        zlib
        zstd
        ${mimalloc}
    GIT_REPOSITORY https://gitlab.freedesktop.org/mesa/mesa.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_TAG main
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --buildtype=release
        --default-library=static
        "-Dc_args='-D__REQUIRED_RPCNDR_H_VERSION__=475'"
        "-Dcpp_args='-D__REQUIRED_RPCNDR_H_VERSION__=475'"
        -Db_lto=true
        ${mpv_lto_mode}
        -Dshared-glapi=disabled
        -Degl=disabled
        -Dgles1=disabled
        -Dgles2=disabled
        -Dgallium-opencl=disabled
        -Dmicrosoft-clc=disabled
        -Dllvm=disabled
        -Dgallium-xa=disabled
        -Denable-glcpp-tests=false
        -Dopengl=false
        -Dosmesa=false
        -Dbuild-tests=false
        -Dcpp_rtti=false
        -Dgallium-drivers=d3d12
        -Dgallium-va=enabled
        -Dgallium-d3d12-video=true
        -Dvideo-codecs=h264dec,h264enc,h265dec,h265enc,vc1dec,av1dec,av1enc,vp9dec
        -Dmin-windows-version=10
        -Dvulkan-drivers=
        -Dtools=
    BUILD_COMMAND ${EXEC} MIMALLOC=1 ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(mesa)
force_meson_configure(mesa)
cleanup(mesa install)
