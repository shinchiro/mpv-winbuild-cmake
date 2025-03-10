ExternalProject_Add(libssh
    DEPENDS
        zlib
        openssl
    GIT_REPOSITORY https://gitlab.com/libssh/libssh-mirror.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --filter=tree:0"
    GIT_PROGRESS TRUE
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 ${CMAKE_COMMAND} -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DWITH_ZLIB=ON
        -DWITH_EXAMPLES=OFF
        -DCMAKE_C_FLAGS='${CMAKE_C_FLAGS} -DHAVE_COMPILER__FUNC__=1'
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
          COMMAND bash -c "echo {'Libs.private: -lwsock32 -liphlpapi','\nRequires.private: libssl','\nCflags.private: -DLIBSSH_STATIC'} >> <BINARY_DIR>/libssh.pc"
    INSTALL_COMMAND ${EXEC} ${CMAKE_COMMAND} --install <BINARY_DIR>
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libssh)
cleanup(libssh install)
