ExternalProject_Add(lzo
    URL "https://fossies.org/linux/misc/lzo-2.10.tar.gz"
    URL_HASH SHA1=4924676a9bae5db58ef129dc1cebce3baa3c4b5d
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/configure
        ${autoreconf_conf_args}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(lzo install)
