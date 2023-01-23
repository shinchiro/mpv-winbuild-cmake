ExternalProject_Add(libpng
    DEPENDS zlib
    GIT_REPOSITORY https://github.com/glennrp/libpng.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        CFLAGS='-fno-asynchronous-unwind-tables'
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
        COMMAND ${CMAKE_COMMAND} -E create_symlink ${MINGW_INSTALL_PREFIX}/bin/libpng-config ${CMAKE_INSTALL_PREFIX}/bin/libpng-config
        COMMAND ${CMAKE_COMMAND} -E create_symlink ${MINGW_INSTALL_PREFIX}/bin/libpng16-config ${CMAKE_INSTALL_PREFIX}/bin/libpng16-config
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libpng)
autoreconf(libpng)
cleanup(libpng install)
