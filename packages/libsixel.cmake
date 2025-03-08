ExternalProject_Add(libsixel
    GIT_REPOSITORY https://github.com/libsixel/libsixel.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !images"
    GIT_PROGRESS TRUE
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup --reconfigure <BINARY_DIR> <SOURCE_DIR>
        ${meson_conf_args}
        -Djpeg=disabled
        -Dpng=disabled
        -Dimg2sixel=disabled
        -Dsixel2png=disabled
        "-Dc_args='-Wno-implicit-function-declaration'"
    BUILD_COMMAND ${EXEC} HIDE=1 ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} meson install -C <BINARY_DIR> --only-changed --tags devel
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libsixel)
cleanup(libsixel install)
