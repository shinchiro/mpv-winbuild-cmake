set(flag
"CFLAGS='-UHAVE_READLINE' LIBREADLINE=''
CC=${TARGET_ARCH}-gcc
AR=${TARGET_ARCH}-ar
RANLIB=${TARGET_ARCH}-ranlib
prefix=${MINGW_INSTALL_PREFIX}")

ExternalProject_Add(mujs
    GIT_REPOSITORY https://github.com/ccxvii/mujs.git
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE} ${flag} build/release/libmujs.a build/release/mujs.pc
    INSTALL_COMMAND install -d ${MINGW_INSTALL_PREFIX}/include
            COMMAND install -d ${MINGW_INSTALL_PREFIX}/lib
            COMMAND install -d ${MINGW_INSTALL_PREFIX}/lib/pkgconfig
            COMMAND install -m 644 mujs.h                  ${MINGW_INSTALL_PREFIX}/include
            COMMAND install -m 644 build/release/libmujs.a ${MINGW_INSTALL_PREFIX}/lib
            COMMAND install -m 644 build/release/mujs.pc   ${MINGW_INSTALL_PREFIX}/lib/pkgconfig
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(mujs)
extra_step(mujs)
