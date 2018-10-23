ExternalProject_Add(crossc
    GIT_REPOSITORY https://github.com/rossy/crossc.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE}
        CXX=${TARGET_ARCH}-g++
        AR=${TARGET_ARCH}-ar
    INSTALL_COMMAND ${MAKE}
        prefix=${MINGW_INSTALL_PREFIX}
        install-static
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(crossc update-submodule
    DEPENDEES download update force-update
    DEPENDERS build
    WORKING_DIRECTORY <SOURCE_DIR>
    COMMAND git submodule update --remote --recursive
    LOG 1
)

force_rebuild_git(crossc)
extra_step(crossc)
