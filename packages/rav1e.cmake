ExternalProject_Add(rav1e
    GIT_REPOSITORY https://github.com/xiph/rav1e.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${EXEC}
        CARGO_BUILD_TARGET_DIR=<BINARY_DIR>
        CARGO_PROFILE_RELEASE_DEBUG=false
        CARGO_PROFILE_RELEASE_INCREMENTAL=false
        CARGO_PROFILE_RELEASE_LTO=off
        ${cargo_lto_rustflags}
        cargo cinstall
        --manifest-path <SOURCE_DIR>/Cargo.toml
        --prefix ${MINGW_INSTALL_PREFIX}
        --target ${TARGET_CPU}-pc-windows-${rust_target}
        -Z build-std=std,panic_abort,core,alloc
        --release
        --library-type staticlib
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(rav1e)
cleanup(rav1e install)
