configure_file(${CMAKE_CURRENT_SOURCE_DIR}/luaexpat-config.in
               ${CMAKE_CURRENT_BINARY_DIR}/luaexpat-config
               @ONLY)

set(LUAEXPAT_MFLAGS CONFIG=${CMAKE_CURRENT_BINARY_DIR}/luaexpat-config)

ExternalProject_Add(luaexpat
    DEPENDS luajit
    GIT_REPOSITORY "https://github.com/LuaDist/luaexpat.git"
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/luaexpat-*.patch
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE} ${LUAEXPAT_MFLAGS}
    INSTALL_COMMAND ${MAKE} ${LUAEXPAT_MFLAGS} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
    BUILD_IN_SOURCE 1
)

force_rebuild_git(luaexpat)
