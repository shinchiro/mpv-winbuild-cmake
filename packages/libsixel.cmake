ExternalProject_Add(libsixel
    DEPENDS
        libpng
        libjpeg
    GIT_REPOSITORY https://github.com/saitoha/libsixel.git
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/configure
        ${autoreconf_conf_args}
        --with-jpeg
        --with-png
        --disable-img2sixel
        --disable-sixel2png
        --disable-python
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libsixel)
cleanup(libsixel install)
