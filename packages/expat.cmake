ExternalProject_Add(expat
    GIT_REPOSITORY https://github.com/libexpat/libexpat.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !testdata"
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR>/expat -B<BINARY_DIR>
        ${cmake_conf_args}
        -DEXPAT_BUILD_DOCS=OFF
        -DEXPAT_BUILD_EXAMPLES=OFF
        -DEXPAT_BUILD_FUZZERS=OFF
        -DEXPAT_BUILD_TESTS=OFF
        -DEXPAT_BUILD_TOOLS=OFF
        -DEXPAT_BUILD_PKGCONFIG=ON
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(expat)
cleanup(expat install)
