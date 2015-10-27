ExternalProject_Add(libmodplug
    DEPENDS gcc
    URL "http://download.sourceforge.net/modplug-xmms/libmodplug-0.8.8.4.tar.gz"
    URL_MD5 fddc3c704c5489de2a3cf0fedfec59db
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(libmodplug)
