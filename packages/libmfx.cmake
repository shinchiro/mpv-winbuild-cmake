ExternalProject_Add(libmfx
    GIT_REPOSITORY https://github.com/lu-zero/mfx_dispatch.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --enable-static
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(libmfx fix-pc
    DEPENDEES install
    WORKING_DIRECTORY ${MINGW_INSTALL_PREFIX}/lib/pkgconfig
    COMMAND mv libmfx.pc mfx.pc
)

force_rebuild_git(libmfx)
autoreconf(libmfx)
cleanup(libmfx fix-pc)
