ExternalProject_Add(mesa
    DEPENDS
        libva
        zlib
        zstd
    GIT_REPOSITORY https://gitlab.freedesktop.org/mesa/mesa.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_TAG main
    GIT_REMOTE_NAME origin
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
        -Dbuild-tests=false
        -Dcpp_rtti=false
        -Degl=disabled
        -Denable-glcpp-tests=false
        -Dgallium-d3d12-video=true
        -Dgallium-drivers=d3d12
        -Dgallium-opencl=disabled
        -Dgallium-va=enabled
        -Dgallium-xa=disabled
        -Dgles1=disabled
        -Dgles2=disabled
        -Dlibunwind=disabled
        -Dllvm=disabled
        -Dmicrosoft-clc=disabled
        -Dmin-windows-version=11
        -Dopengl=false
        -Dosmesa=false
        -Dshared-glapi=disabled
        -Dspirv-to-dxil=false
        -Dtools=
        -Dvideo-codecs=all
        -Dvulkan-drivers=microsoft-experimental
        -Dzlib=enabled
        -Dzstd=enabled
    BUILD_COMMAND ${EXEC} WPD=0 CFI=0 ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} WPD=0 CFI=0 ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(mesa)
force_meson_configure(mesa)
cleanup(mesa install)
