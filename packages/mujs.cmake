set(flag
"CFLAGS='-UHAVE_READLINE' LIBREADLINE=''
CC=${TARGET_ARCH}-gcc
AR=${TARGET_ARCH}-ar
RANLIB=${TARGET_ARCH}-ranlib
prefix=${MINGW_INSTALL_PREFIX}")

ExternalProject_Add(mujs
    GIT_REPOSITORY git://git.ghostscript.com/mujs.git
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE} ${flag}
    INSTALL_COMMAND ${MAKE} ${flag} install-static
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(mujs rename-executablesuffix
    DEPENDEES build
    DEPENDERS install
    WORKING_DIRECTORY <SOURCE_DIR>/build/release
    COMMAND mv mujs.exe mujs
    LOG 1
)

force_rebuild_git(mujs)
extra_step(mujs)
