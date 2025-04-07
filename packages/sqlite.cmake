ExternalProject_Add(sqlite
    URL https://www.sqlite.org/2020/sqlite-autoconf-3330000.tar.gz
    URL_HASH SHA3_256=6e94e9453cedf8f2023e3923f856741d1e28a2271e9f93d24d95fa48870edaad
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ${EXEC} autoreconf -fi && CONF=1 <SOURCE_DIR>/configure
        ${autoreconf_conf_args}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(sqlite install)
