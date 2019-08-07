ExternalProject_Add(sqlite
    URL https://www.sqlite.org/2019/sqlite-autoconf-3290000.tar.gz
    URL_HASH SHA1=053d8237eb9741b0e297073810668c2611a8e38e
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
