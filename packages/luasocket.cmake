set(LUASOCKET_MFLAGS CC=${TARGET_ARCH}-gcc LD=${TARGET_ARCH}-gcc
    PLAT=mingw
    LUAINC=${MINGW_INSTALL_PREFIX}/include/luajit-2.0
    LUALIB=${MINGW_INSTALL_PREFIX}/lib/libluajit-5.1.a
    LUAV=5.1
    prefix=${MINGW_INSTALL_PREFIX})

ExternalProject_Add(luasocket
    DEPENDS luajit
    GIT_REPOSITORY "https://github.com/diegonehab/luasocket.git"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE} ${LUASOCKET_MFLAGS}
    INSTALL_COMMAND ${MAKE} ${LUASOCKET_MFLAGS} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
    BUILD_IN_SOURCE 1
)

force_rebuild_git(luasocket)
