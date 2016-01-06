ExternalProject_Add(angle
    DEPENDS gcc
    GIT_REPOSITORY https://chromium.googlesource.com/angle/angle
    #GIT_DEPTH 1
    GIT_TAG 444922662a59a45ad8f86ec9480b180571337f4e
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/angle-*.patch
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${MAKE}
        CXX=${TARGET_ARCH}-g++
        AR=${TARGET_ARCH}-ar
        RANLIB=${TARGET_ARCH}-ranlib
        PREFIX=${MINGW_INSTALL_PREFIX}
        install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

#force_rebuild_git(angle)
