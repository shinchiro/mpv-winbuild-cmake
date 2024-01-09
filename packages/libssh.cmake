ExternalProject_Add(libssh
    DEPENDS
        zlib
        openssl
    GIT_REPOSITORY https://gitlab.com/libssh/libssh-mirror.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
        -DWITH_ZLIB=ON
        -DWITH_EXAMPLES=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
          COMMAND bash -c "echo {'Libs.private: -lwsock32 -liphlpapi -lpthread','\nRequires.private: libssl','\nCflags.private: -DLIBSSH_STATIC'} >> <BINARY_DIR>/libssh.pc"
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libssh)
cleanup(libssh install)
