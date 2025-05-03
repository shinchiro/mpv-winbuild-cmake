ExternalProject_Add(speex
    DEPENDS
        ogg 
    GIT_REPOSITORY https://github.com/xiph/speex.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
        ${meson_conf_args}
        -Dtest-binaries=disabled
        -Dtools=disabled
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(speex)
cleanup(speex install)
force_meson_configure(speex)
