ExternalProject_Add(libplacebo
    DEPENDS
        vulkan
        shaderc
        lcms2
        glad
    GIT_REPOSITORY https://github.com/haasn/libplacebo.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SHALLOW 1
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} meson <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --buildtype=release
        --default-library=static
        -Dvulkan-registry='${MINGW_INSTALL_PREFIX}/share/vulkan/registry/vk.xml'
        -Ddemos=false
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

get_property(src_glad TARGET glad PROPERTY _EP_SOURCE_DIR)

ExternalProject_Add_Step(libplacebo symlink
    DEPENDEES download update patch
    DEPENDERS configure
    WORKING_DIRECTORY <SOURCE_DIR>/3rdparty
    COMMAND rm -rf glad
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${src_glad} glad
    COMMENT "Symlinking glad"
)

force_rebuild_git(libplacebo)
force_meson_configure(libplacebo)
cleanup(libplacebo install)
