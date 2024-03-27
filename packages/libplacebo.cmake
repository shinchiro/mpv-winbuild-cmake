get_property(src_glad TARGET glad PROPERTY _EP_SOURCE_DIR)
get_property(src_fast_float TARGET fast_float PROPERTY _EP_SOURCE_DIR)
ExternalProject_Add(libplacebo
    DEPENDS
        vulkan
        shaderc
        spirv-cross
        lcms2
        glad
        fast_float
        libdovi
        xxhash
    GIT_REPOSITORY https://github.com/haasn/libplacebo.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    COMMAND bash -c "rm -rf <SOURCE_DIR>/3rdparty/glad"
    COMMAND bash -c "rm -rf <SOURCE_DIR>/3rdparty/fast_float"
    COMMAND bash -c "ln -s ${src_glad} <SOURCE_DIR>/3rdparty/glad"
    COMMAND bash -c "ln -s ${src_fast_float} <SOURCE_DIR>/3rdparty/fast_float"
    COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --default-library=static
        -Dd3d11=enabled
        -Ddebug=true
        -Db_ndebug=true
        -Doptimization=3
        -Dvulkan-registry='${MINGW_INSTALL_PREFIX}/share/vulkan/registry/vk.xml'
        -Ddemos=false
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libplacebo)
force_meson_configure(libplacebo)
cleanup(libplacebo install)
