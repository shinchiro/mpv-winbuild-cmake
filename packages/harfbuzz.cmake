ExternalProject_Add(harfbuzz
    DEPENDS
        freetype2
        libpng
    GIT_REPOSITORY https://github.com/harfbuzz/harfbuzz.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_REMOTE_NAME origin
    GIT_TAG main
    GIT_CLONE_FLAGS "--depth=1 --sparse --filter=tree:0"
    GIT_PROGRESS TRUE
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !test"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup --reconfigure <BINARY_DIR> <SOURCE_DIR>
        ${meson_conf_args}
        -Dunity=on
        -Dunity_size=1024
        -Dfreetype=enabled
        -Dgdi=enabled
        -Ddirectwrite=enabled
        -Dicu=disabled
        -Dglib=disabled
        -Dgobject=disabled
        -Dtests=disabled
        -Dutilities=disabled
        -Ddocs=disabled
        -Dbenchmark=disabled
        "-Dc_args='-DHB_NO_AAT -DHB_NO_LEGACY -DHB_NO_PRAGMA_GCC_DIAGNOSTIC_ERROR'"
        "-Dcpp_args='-DHB_NO_AAT -DHB_NO_LEGACY -DHB_NO_PRAGMA_GCC_DIAGNOSTIC_ERROR'"
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} meson install -C <BINARY_DIR> --only-changed --tags devel
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(harfbuzz)
cleanup(harfbuzz install)
