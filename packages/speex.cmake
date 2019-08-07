ExternalProject_Add(speex
    DEPENDS ogg
    URL "https://ftp.osuosl.org/pub/xiph/releases/speex/speex-1.2.0.tar.gz"
    URL_HASH SHA256=eaae8af0ac742dc7d542c9439ac72f1f385ce838392dc849cae4536af9210094
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC}
        LIBS=-lwinmm
        <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(speex)
autoreconf(speex)
