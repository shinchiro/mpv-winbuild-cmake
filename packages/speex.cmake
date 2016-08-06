ExternalProject_Add(speex
    DEPENDS ogg
    URL "http://downloads.xiph.org/releases/speex/speex-1.2rc2.tar.gz"
    URL_HASH SHA256=caa27c7247ff15c8521c2ae0ea21987c9e9710a8f2d3448e8b79da9806bce891
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC}
        LIBS=-lwinmm
        <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-oggtest
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(speex)
force_rebuild(speex)
autoreconf(speex)
