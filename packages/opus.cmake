ExternalProject_Add(opus
    DEPENDS gcc
    URL "http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz"
    URL_HASH SHA256=b9727015a58affcf3db527322bf8c4d2fcf39f5f6b8f15dbceca20206cbe1d95
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(opus)