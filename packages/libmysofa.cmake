ExternalProject_Add(libmysofa
    DEPENDS zlib
    GIT_REPOSITORY https://github.com/hoene/libmysofa.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_REMOTE_NAME origin
    GIT_TAG main
    GIT_CLONE_FLAGS "--depth=1 --sparse --filter=tree:0"
    GIT_PROGRESS TRUE
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !tests"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 ${CMAKE_COMMAND} -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DBUILD_TESTS=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ${CMAKE_COMMAND} --install <BINARY_DIR>
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libmysofa)
cleanup(libmysofa install)
