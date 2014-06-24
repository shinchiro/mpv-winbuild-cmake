set(LUAEXPAT_MFLAGS
    LUA_CDIR=${MINGW_INSTALL_PREFIX}/lua/5.1
    LUA_LDIR=${MINGW_INSTALL_PREFIX}/lua/5.1/lua
    LUA_INC=-I${MINGW_INSTALL_PREFIX}/include/luajit-2.0
    EXPAT_INC=-I${MINGW_INSTALL_PREFIX}/include
    CC=${TARGET_ARCH}-gcc
    "COMMON_LDFLAGS='-s -shared'"
    LDFLAGS=-lluajit-5.1
    LIBNAME=lxp.dll
)

ExternalProject_Add(luaexpat
    DEPENDS luajit expat
    GIT_REPOSITORY "https://github.com/LuaDist/luaexpat.git"
    UPDATE_COMMAND ""
#     PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/luaexpat-*.patch
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE} ${LUAEXPAT_MFLAGS}
    INSTALL_COMMAND ${MAKE} ${LUAEXPAT_MFLAGS} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
    BUILD_IN_SOURCE 1
)

force_rebuild_git(luaexpat)
