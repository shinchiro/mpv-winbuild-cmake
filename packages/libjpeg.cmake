ExternalProject_Add(libjpeg
    GIT_REPOSITORY https://github.com/libjpeg-turbo/libjpeg-turbo.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_REMOTE_NAME origin
    GIT_TAG main
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DENABLE_SHARED=OFF
        -DENABLE_STATIC=ON
        -DCMAKE_BUILD_TYPE=Release
    BUILD_COMMAND ${CMAKE_MAKE_PROGRAM}
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libjpeg)
cleanup(libjpeg install)
