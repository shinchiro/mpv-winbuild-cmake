ExternalProject_Add(sqlite
    URL https://www.sqlite.org/2020/sqlite-autoconf-3310100.tar.gz
    URL_HASH SHA1=0c30f5b22152a8166aa3bebb0f4bc1f3e9cc508b
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
