ExternalProject_Add(mingw-w64
    PREFIX mingw-w64-prefix
    GIT_REPOSITORY https://github.com/mirror/mingw-w64.git
    GIT_TAG 5c8702bbb0228313e74618dac943682b95a4ce17
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1
)

force_rebuild_git(mingw-w64)
