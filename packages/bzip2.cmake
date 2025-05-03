ExternalProject_Add(bzip2
    GIT_REPOSITORY https://gitlab.com/bzip2/bzip2.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DENABLE_LIB_ONLY=ON
        -DENABLE_SHARED_LIB=OFF
        -DENABLE_STATIC_LIB=ON
        -DENABLE_TESTS=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
            COMMAND bash -c "mv ${MINGW_INSTALL_PREFIX}/lib/libbz2_static.a ${MINGW_INSTALL_PREFIX}/lib/libbz2.a"
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(bzip2)
cleanup(bzip2 install)
