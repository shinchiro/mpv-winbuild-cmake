set(DEBPATCH ${CMAKE_CURRENT_BINARY_DIR}/lame-prefix/src/patch.sh)
file(WRITE ${DEBPATCH}
"#!/bin/bash
for i in $(cat debian/patches/series); do
    patch -N -p1 < debian/patches/$i || true
done")

ExternalProject_Add(lame
    GIT_REPOSITORY https://gitlab.com/shinchiro/lame.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    PATCH_COMMAND chmod 755 ${DEBPATCH} && ${DEBPATCH}
    CONFIGURE_COMMAND ${EXEC} autoreconf -fi && CONF=1 <SOURCE_DIR>/configure
        ${autoreconf_conf_args}
        --disable-frontend
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(lame)
cleanup(lame install)
