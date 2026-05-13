ExternalProject_Add(ngtcp2
    DEPENDS
        openssl
    GIT_REPOSITORY https://github.com/ngtcp2/ngtcp2.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !tests"
    GIT_SUBMODULES ""
    GIT_TAG main
    GIT_REMOTE_NAME origin
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} ${CMAKE_COMMAND} -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
        -DENABLE_LIB_ONLY=ON
        -DENABLE_STATIC_LIB=ON
        -DENABLE_SHARED_LIB=OFF
        -DBUILD_TESTING=OFF
        "-DCMAKE_C_FLAGS='-lz -lbrotlienc -lbrotlidec -lbrotlicommon -lzstd -lcrypt32'"
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ${CMAKE_COMMAND} --install <BINARY_DIR>
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(ngtcp2)
cleanup(ngtcp2 install)
