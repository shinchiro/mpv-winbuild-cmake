ExternalProject_Add(subrandr
    DEPENDS
        freetype2
        harfbuzz
        fontconfig
    GIT_REPOSITORY https://github.com/afishhh/subrandr.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_REMOTE_NAME origin
    GIT_TAG master
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${EXEC}
        LD_PRELOAD=
        CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1
        ${cargo_lto_rustflags}
        cargo -Z unstable-options -C <SOURCE_DIR> xtask install
        --prefix ${MINGW_INSTALL_PREFIX}
        --target ${TARGET_CPU}-pc-windows-${rust_target}
        --static-library true
        --shared-library false
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(subrandr)
cleanup(subrandr install)
