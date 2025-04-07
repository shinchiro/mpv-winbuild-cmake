ExternalProject_Add(xxhash
    GIT_REPOSITORY https://github.com/Cyan4973/xxHash.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_TAG dev
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR>/cmake_unofficial -B<BINARY_DIR>
        ${cmake_conf_args}
        -DXXHASH_BUILD_XXHSUM=OFF
        ${xxhash_dispatch}
        -DCMAKE_C_FLAGS='${CMAKE_C_FLAGS} ${xxhash_cflags}'
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(xxhash)
cleanup(xxhash install)
