ExternalProject_Add(fribidi
    DEPENDS gcc
    URL "http://fribidi.org/download/fribidi-0.19.6.tar.bz2"
    URL_HASH SHA256=cba8b7423c817e5adf50d28ec9079d14eafcec9127b9e8c8f1960c5ad585e17d
    PATCH_COMMAND sed -i "s,__declspec(dllimport),," "lib/fribidi-common.h"
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-deprecated
        --without-glib
        --enable-charsets
        --enable-malloc
    BUILD_COMMAND ${MAKE} -j1 # breaks with parallel make
    INSTALL_COMMAND ${MAKE} -j1 install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
