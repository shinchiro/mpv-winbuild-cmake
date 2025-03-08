ExternalProject_Add(libsdl2
    DEPENDS
        vulkan
        libiconv
        libsamplerate
    GIT_REPOSITORY https://github.com/libsdl-org/SDL.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --no-single-branch --sparse --filter=tree:0"
    GIT_PROGRESS TRUE
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !test"
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG SDL2
    CONFIGURE_COMMAND ${EXEC} CONF=1 ${CMAKE_COMMAND} -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DSDL_VULKAN=ON
        -DSDL_LIBICONV=ON
        -DSDL_SYSTEM_ICONV=ON
        -DSDL_LIBSAMPLERATE=ON
        -DSDL_MMX=OFF
        -DSDL_SSE=OFF
        -DSDL_SSE2=OFF
        -DSDL_SSE3=OFF
        -DSDL_CCACHE=OFF
        -DSDL_TEST=OFF
        -DSDL_TEST_LIBRARY=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ${CMAKE_COMMAND} --install <BINARY_DIR>
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libsdl2)
cleanup(libsdl2 install)
