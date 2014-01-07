# luajit ships with a broken pkg-config file
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/luajit.pc.in ${CMAKE_CURRENT_BINARY_DIR}/luajit.pc @ONLY)

ExternalProject_Add(luajit
    DEPENDS
        gcc
        libiconv
    GIT_REPOSITORY "http://luajit.org/git/luajit-2.0.git"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE} "HOST_CC='gcc -m32'" CROSS=${TARGET_ARCH}- TARGET_SYS=Windows BUILDMODE=static amalg
    INSTALL_COMMAND ${MAKE} "HOST_CC='gcc -m32'" CROSS=${TARGET_ARCH}- TARGET_SYS=Windows BUILDMODE=static FILE_T=luajit.exe install PREFIX=${MINGW_INSTALL_PREFIX}
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(luajit)

ExternalProject_Add_Step(luajit install-pc
    DEPENDEES install
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/luajit.pc ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/luajit.pc
)
