ExternalProject_Add(angle
    DEPENDS 
        ffmpeg
    GIT_REPOSITORY https://chromium.googlesource.com/angle/angle
    GIT_DEPTH 1
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/angle-*.patch
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE} clean
    INSTALL_COMMAND ${MAKE}
        CXX=${TARGET_ARCH}-g++
        AR=${TARGET_ARCH}-ar
        RANLIB=${TARGET_ARCH}-ranlib
        PREFIX=${MINGW_INSTALL_PREFIX}
        install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(angle)
