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
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/megasdk-*.patch
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --enable-static
        --disable-shared
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
autogen(megasdk)
extra_step(megasdk)
