ExternalProject_Add(sqlite
    URL https://www.sqlite.org/2018/sqlite-autoconf-3220000.tar.gz
    URL_HASH SHA256=2824ab1238b706bc66127320afbdffb096361130e23291f26928a027b885c612
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --enable-static
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

autoreconf(sqlite)
extra_step(sqlite)
