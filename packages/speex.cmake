ExternalProject_Add(speex
    DEPENDS
        ogg
    GIT_REPOSITORY https://github.com/xiph/speex.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --filter=tree:0"
    GIT_PROGRESS TRUE
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup --reconfigure <BINARY_DIR> <SOURCE_DIR>
        ${meson_conf_args}
        -Dtest-binaries=disabled
        -Dtools=disabled
        "-Dc_args='-Dlsp_to_lpc=speex_lsp_to_lpc -Dlpc_to_lsp=speex_lpc_to_lsp'"
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} meson install -C <BINARY_DIR> --only-changed --tags devel
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(speex)
cleanup(speex install)
