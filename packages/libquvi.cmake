ExternalProject_Add(libquvi
    DEPENDS luajit libquvi_scripts libcurl glib luasocket luaexpat libgcrypt
    GIT_REPOSITORY "git://repo.or.cz/libquvi.git"
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/libquvi-*.patch
    CONFIGURE_COMMAND ${EXEC}
        CFLAGS=-DCURL_STATICLIB
        <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --enable-static
        --with-scriptsdir=libquvi-scripts
        --without-manual
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
    BUILD_IN_SOURCE 1
)

force_rebuild_git(libquvi)
autoreconf(libquvi)
