ExternalProject_Add(libdovi
    GIT_REPOSITORY https://github.com/quietvoid/dovi_tool.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_REMOTE_NAME origin
    GIT_TAG main
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${EXEC} cargo
        --config profile.release.codegen-units=1
        cinstall
        --manifest-path <SOURCE_DIR>/dolby_vision/Cargo.toml
        --prefix ${MINGW_INSTALL_PREFIX}
        --target ${TARGET_CPU}-pc-windows-gnu
        --release
        --library-type staticlib
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libdovi)
cleanup(libdovi install)
