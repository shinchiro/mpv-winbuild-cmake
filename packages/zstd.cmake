ExternalProject_Add(zstd
    GIT_REPOSITORY https://github.com/facebook/zstd.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG dev
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR>/build/cmake -B<BINARY_DIR>
        ${cmake_conf_args}
        -DZSTD_BUILD_CONTRIB=OFF
        -DZSTD_BUILD_TESTS=OFF
        -DZSTD_LEGACY_SUPPORT=OFF
        -DZSTD_BUILD_PROGRAMS=OFF
        -DZSTD_PROGRAMS_LINK_SHARED=OFF
        -DZSTD_BUILD_SHARED=OFF
        -DZSTD_BUILD_STATIC=ON
        -DZSTD_MULTITHREAD_SUPPORT=ON
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(zstd)
cleanup(zstd install)
