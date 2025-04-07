ExternalProject_Add(libaribcaption
    DEPENDS
        fontconfig
        freetype2
        openssl
    GIT_REPOSITORY https://github.com/xqq/libaribcaption.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DARIBCC_BUILD_TESTS=OFF
        -DARIBCC_SHARED_LIBRARY=OFF
        -DARIBCC_USE_EMBEDDED_FREETYPE=OFF
        -DARIBCC_NO_RTTI=ON
        -DARIBCC_USE_FONTCONFIG=ON
        -DARIBCC_USE_FREETYPE=ON
        "-DCMAKE_C_FLAGS='-DHAVE_OPENSSL=1'"
        "-DCMAKE_CXX_FLAGS='-DHAVE_OPENSSL=1'"
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libaribcaption)
cleanup(libaribcaption install)
