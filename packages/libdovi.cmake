ExternalProject_Add(libdovi
    GIT_REPOSITORY https://github.com/quietvoid/dovi_tool.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone dolby_vision"
    GIT_REMOTE_NAME origin
    GIT_TAG main
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${EXEC}
        LD_PRELOAD=
        CARGO_BUILD_TARGET_DIR=<BINARY_DIR>
        CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1
        ${cargo_lto_rustflags}
        cargo cinstall
        --manifest-path <SOURCE_DIR>/dolby_vision/Cargo.toml
        --prefix ${MINGW_INSTALL_PREFIX}
        --target ${TARGET_CPU}-pc-windows-gnullvm
        -Zbuild-std=std,panic_abort
        -Zbuild-std-features=unwind/system-llvm-libunwind,core/panic_immediate_abort
        --release
        --library-type staticlib
    INSTALL_COMMAND ${EXEC} llvm-ar t ${MINGW_INSTALL_PREFIX}/lib/libdovi.a | grep '^compiler_builtins.*\.o$' | xargs -I {} llvm-ar d ${MINGW_INSTALL_PREFIX}/lib/libdovi.a {}
            COMMAND ${EXEC} llvm-ar t ${MINGW_INSTALL_PREFIX}/lib/libdovi.a | grep '^unwind.*\.o$' | xargs -I {} llvm-ar d ${MINGW_INSTALL_PREFIX}/lib/libdovi.a {}
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libdovi)
cleanup(libdovi install)
