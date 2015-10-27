ExternalProject_Add(libwaio
    DEPENDS gcc
    GIT_REPOSITORY "git://midipix.org/waio"
    GIT_DEPTH 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${EXEC} ./build-mingw-nt${TARGET_BITS} lib-static
    INSTALL_COMMAND ${CMAKE_COMMAND} -E remove_directory ${MINGW_INSTALL_PREFIX}/include/waio
        COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/include/waio ${MINGW_INSTALL_PREFIX}/include/waio
        COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/lib${TARGET_BITS}/libwaio.a ${MINGW_INSTALL_PREFIX}/lib/libwaio.a
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libwaio)
