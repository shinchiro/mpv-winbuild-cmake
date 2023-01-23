set(flag
"CFLAGS='-UHAVE_READLINE' LIBREADLINE=''
CC=${TARGET_ARCH}-gcc
AR=${TARGET_ARCH}-ar
RANLIB=${TARGET_ARCH}-ranlib
OUT=<BINARY_DIR>
prefix=${MINGW_INSTALL_PREFIX}
host=mingw")

ExternalProject_Add(mujs
    GIT_REPOSITORY https://github.com/ccxvii/mujs.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    PATCH_COMMAND ${EXEC} git am --3way ${CMAKE_CURRENT_SOURCE_DIR}/mujs-*.patch
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE} -C <SOURCE_DIR> ${flag}
    INSTALL_COMMAND ${MAKE} -C <SOURCE_DIR> ${flag} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(mujs)
cleanup(mujs install)
