ExternalProject_Add(libmysofa
    DEPENDS zlib
    GIT_REPOSITORY https://github.com/hoene/libmysofa.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_REMOTE_NAME origin
    GIT_TAG main
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DBUILD_SHARED_LIBS=OFF
        -DBUILD_TESTS=OFF
        -DCMAKE_BUILD_TYPE=Release
    BUILD_COMMAND ${CMAKE_MAKE_PROGRAM}
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libmysofa)
cleanup(libmysofa install)
