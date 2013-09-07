configure_file(${CMAKE_CURRENT_SOURCE_DIR}/lua.pc.in ${CMAKE_CURRENT_BINARY_DIR}/lua.pc @ONLY)

ExternalProject_Add(lua
    DEPENDS gcc
    URL "http://www.lua.org/ftp/lua-5.1.5.tar.gz"
    URL_MD5 2e115fe26e435e33b0d5c022e4490567
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE} CC=${TARGET_ARCH}-gcc "AR='${TARGET_ARCH}-ar rcu'" RANLIB=${TARGET_ARCH}-ranlib generic
    INSTALL_COMMAND ${MAKE} install INSTALL_TOP=${MINGW_INSTALL_PREFIX}
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(lua install-pc
    DEPENDEES install
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/lua.pc ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/lua.pc
)
