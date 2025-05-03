ExternalProject_Add(rubberband
    DEPENDS
        libsamplerate
    GIT_REPOSITORY https://github.com/breakfastquay/rubberband.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_REMOTE_NAME origin
    GIT_TAG default
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
        ${meson_conf_args}
        -Dfft=builtin
        -Dresampler=libsamplerate
        -Djni=disabled
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(rubberband)
force_meson_configure(rubberband)
cleanup(rubberband install)
