ExternalProject_Add(mesa
    DEPENDS
        directx-header
    GIT_REPOSITORY https://gitlab.freedesktop.org/mesa/mesa.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_TAG main
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} meson <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --buildtype=release
        --default-library=static
        -Db_lto=true
        ${mpv_lto_mode}
        -Dshared-glapi=disabled
        -Degl=disabled
        -Dgles1=disabled
        -Dgles2=disabled
        -Dopengl=false
        -Dllvm=disabled
        -Dshared-llvm=disabled
        -Dosmesa=false
        -Dbuild-tests=false
        -Dgallium-drivers=d3d12
        -Dgallium-va=enabled
        -Dgallium-d3d12-video=true
        -Dgallium-xa=disabled
        -Denable-glcpp-tests=false
        -Dtools=
        -Dvideo-codecs=h264dec,h264enc,h265dec,h265enc,vc1dec
        -Dmicrosoft-clc=disabled
        -Dstatic-libclc=all
        -Dcpp_rtti=false
        -Dmin-windows-version=11
        -Dgallium-opencl=disabled
        -Dopencl-spirv=false
        -Dvulkan-drivers=
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(mesa)
force_meson_configure(mesa)
cleanup(mesa install)

