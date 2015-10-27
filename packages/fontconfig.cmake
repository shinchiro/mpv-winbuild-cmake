ExternalProject_Add(fontconfig
    DEPENDS expat freetype2 zlib
    GIT_REPOSITORY "git://anongit.freedesktop.org/fontconfig"
    GIT_DEPTH 1
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/fontconfig-*.patch
    CONFIGURE_COMMAND ${EXEC}
        PYTHON=python2
        <SOURCE_DIR>/configure
        --build=${HOST_ARCH}
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --with-arch=${TARGET_ARCH}
        --with-expat=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(fontconfig)
force_rebuild_git(fontconfig)
autogen(fontconfig)
