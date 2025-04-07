ExternalProject_Add(libsoxr
    GIT_REPOSITORY https://gitlab.com/shinchiro/soxr.git
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    GIT_CLONE_FLAGS "--filter=tree:0"
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DBUILD_TESTS=OFF
        -DWITH_OPENMP=OFF
        -DHAVE_WORDS_BIGENDIAN_EXITCODE=1
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libsoxr)
cleanup(libsoxr install)
