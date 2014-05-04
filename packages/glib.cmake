ExternalProject_Add(glib
    DEPENDS gettext libffi pcre
    GIT_REPOSITORY "https://github.com/GNOME/glib.git"
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/glib-*.patch
    CONFIGURE_COMMAND ${EXEC}
        <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --enable-static
        --with-threads=win32
        --with-pcre=system
        --with-libiconv=gnu
        --disable-inotify
        CXX=${TARGET_ARCH}-c++
    BUILD_COMMAND ${MAKE} -C glib
        COMMAND ${MAKE} -C gmodule
        COMMAND ${MAKE} -C gthread
        COMMAND ${MAKE} -C gobject
#         COMMAND ${MAKE} -C gio
    INSTALL_COMMAND ${MAKE} -C glib install
        COMMAND ${MAKE} -C gmodule install
        COMMAND ${MAKE} -C gthread install
        COMMAND ${MAKE} -C gobject install
#         COMMAND ${MAKE} -C gio install
        COMMAND ${MAKE} install-pkgconfigDATA
        COMMAND ${MAKE} -C m4macros install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

autogen(glib)
