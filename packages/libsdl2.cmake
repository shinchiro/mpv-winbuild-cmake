ExternalProject_Add(libsdl2
    DEPENDS
        vulkan
        libiconv
    GIT_REPOSITORY https://github.com/libsdl-org/SDL.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !test"
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG SDL2
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DSDL_VULKAN=ON
        -DSDL_TEST=OFF
        -DSDL_TEST_LIBRARY=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libsdl2)
cleanup(libsdl2 install)
