ExternalProject_Add(mingw-w64
    PREFIX mingw-w64-prefix
    GIT_REPOSITORY https://github.com/mirror/mingw-w64.git
    GIT_TAG 7faa2f348c838f2043a40ae7acca913b94607d5c
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1
)

force_rebuild_git(mingw-w64)
