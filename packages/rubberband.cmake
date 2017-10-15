ExternalProject_Add(rubberband
    GIT_REPOSITORY https://github.com/lachs0r/rubberband.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE} CC=${TARGET_ARCH}-gcc CXX=${TARGET_ARCH}-g++ AR=${TARGET_ARCH}-ar static
    INSTALL_COMMAND ${MAKE} PREFIX=${MINGW_INSTALL_PREFIX} install-static
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(rubberband)
extra_step(rubberband)
