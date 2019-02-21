ExternalProject_Add(mujs
    GIT_REPOSITORY git://git.ghostscript.com/mujs.git
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE}
        CFLAGS='-UHAVE_READLINE' LIBREADLINE='' # undefine readline as we dont want readline
        CC=${TARGET_ARCH}-gcc
        AR=${TARGET_ARCH}-ar
        RANLIB=${TARGET_ARCH}-ranlib
        prefix=${MINGW_INSTALL_PREFIX}
        build/release/libmujs.a
        build/release/mujs.pc
    INSTALL_COMMAND install -d ${MINGW_INSTALL_PREFIX}/include
            COMMAND install -d ${MINGW_INSTALL_PREFIX}/lib
            COMMAND install -d ${MINGW_INSTALL_PREFIX}/lib/pkgconfig
            COMMAND install -m644 mujs.h  ${MINGW_INSTALL_PREFIX}/include
            COMMAND install -m644 build/release/libmujs.a ${MINGW_INSTALL_PREFIX}/lib
            COMMAND install -m644 build/release/mujs.pc ${MINGW_INSTALL_PREFIX}/lib/pkgconfig
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(mujs)
extra_step(mujs)
