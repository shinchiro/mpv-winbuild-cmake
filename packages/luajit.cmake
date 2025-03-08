ExternalProject_Add(luajit
    DEPENDS
        libiconv
        luajit-wrap
    GIT_REPOSITORY https://github.com/LuaJIT/LuaJIT.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --filter=tree:0"
    GIT_PROGRESS TRUE
    GIT_REMOTE_NAME origin
    GIT_TAG v2.1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(luajit)
cleanup(luajit install)
