if(${TARGET_CPU} MATCHES "x86_64")
    set(libdovi_target "x86_64-pc-windows-gnu")
else()
    set(libdovi_target "i686-pc-windows-gnu")
endif()

ExternalProject_Add(libdovi
    GIT_REPOSITORY https://github.com/quietvoid/dovi_tool.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_TAG libdovi-3.1.1
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${EXEC} cargo cinstall
        --manifest-path <SOURCE_DIR>/dolby_vision/Cargo.toml
        --prefix ${MINGW_INSTALL_PREFIX}
        --target ${libdovi_target}
        --release
        --library-type staticlib
    LOG_DOWNLOAD 1 LOG_UPDATE 1
)

ExternalProject_Add_Step(libdovi delete-cache
    DEPENDEES install
    WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}/.cargo
    COMMAND rm -rf git registry
    COMMENT "Delete cache"
    LOG 1
)

force_rebuild_git(libdovi)
cleanup(libdovi install)
