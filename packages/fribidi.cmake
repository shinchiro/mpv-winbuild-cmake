ExternalProject_Add(fribidi
    DEPENDS gcc
    URL "http://fribidi.org/download/fribidi-0.19.5.tar.bz2"
    URL_MD5 925bafb97afee8a2fc2d0470c072a155
    PATCH_COMMAND sed -i "s,__declspec(dllimport),," "lib/fribidi-common.h"
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-deprecated
        --without-glib
        --enable-charsets
    BUILD_COMMAND ${MAKE} -j1 # breaks with parallel make
    INSTALL_COMMAND ${MAKE} -j1 install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
