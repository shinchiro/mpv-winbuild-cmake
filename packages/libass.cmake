ExternalProject_Add(libass
    DEPENDS
        harfbuzz
        freetype2
        fribidi
        libiconv
        fontconfig
        libunibreak
    GIT_REPOSITORY https://github.com/rcombs/libass.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --no-single-branch --filter=tree:0"
    GIT_PROGRESS TRUE
    GIT_REMOTE_NAME origin
    GIT_TAG threading
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup --reconfigure <BINARY_DIR> <SOURCE_DIR>
        ${meson_conf_args}
        -Dfontconfig=enabled
        -Ddirectwrite=enabled
        -Dasm=enabled
        -Dlibunibreak=enabled
        -Dthreads=enabled
        -Dtest=disabled
        -Dcompare=disabled
        -Dprofile=disabled
        -Dfuzz=disabled
        -Dcheckasm=disabled
    ${novzeroupper} <SOURCE_DIR>/libass/x86/x86inc.asm
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} meson install -C <BINARY_DIR> --only-changed --tags devel
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libass)
cleanup(libass install)
