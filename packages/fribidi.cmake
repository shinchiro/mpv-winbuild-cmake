if(CMAKE_SYSTEM_NAME MATCHES "Linux" AND NOT CMAKE_SYSTEM_VERSION MATCHES "Microsoft")
    find_program(WINE wine)
    set(TARGET_EXEC "TARGET_EXEC=${WINE}")
endif()

ExternalProject_Add(fribidi
    GIT_REPOSITORY https://github.com/fribidi/fribidi.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/fribidi-*.patch
    CONFIGURE_COMMAND ${EXEC} PKG_CONFIG=pkg-config <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --enable-static
        --disable-deprecated
        --without-glib
        --enable-charsets
    BUILD_COMMAND ${MAKE} -j1 ${TARGET_EXEC} # breaks with parallel make
    INSTALL_COMMAND ${MAKE} -j1 install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(fribidi)
extra_step(fribidi)
autoreconf(fribidi)
