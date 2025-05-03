ExternalProject_Add(gmp
    URL https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz
    URL_HASH SHA256=a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/configure
        ${autoreconf_conf_args}
        CC_FOR_BUILD=cc
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(gmp install)
