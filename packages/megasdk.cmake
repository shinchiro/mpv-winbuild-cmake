ExternalProject_Add(megasdk
    DEPENDS
        zlib
        cryptopp
        sqlite
        termcap
        readline
        libuv
        libsodium
    GIT_REPOSITORY https://github.com/meganz/sdk.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am --3way ${CMAKE_CURRENT_SOURCE_DIR}/megasdk-*.patch
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/autogen.sh && CONF=1 <SOURCE_DIR>/configure
        ${autoreconf_conf_args}
        --disable-silent-rules
        --without-openssl
        --without-cares
        --without-curl
        --without-freeimage
        --with-winhttp=${MINGW_INSTALL_PREFIX}
        --with-termcap=${MINGW_INSTALL_PREFIX}
        --with-readline=${MINGW_INSTALL_PREFIX}
        --with-libuv=${MINGW_INSTALL_PREFIX}
        --with-sodium=${MINGW_INSTALL_PREFIX}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install-strip
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(megasdk)
cleanup(megasdk install)
