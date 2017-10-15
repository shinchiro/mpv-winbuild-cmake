ExternalProject_Add(openal-soft
    GIT_REPOSITORY git://repo.or.cz/openal-soft.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/openal-soft-*.patch
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_BINARY_DIR}/../toolchain.cmake
        -DLIBTYPE=STATIC
        -DALSOFT_UTILS=OFF
        -DALSOFT_EXAMPLES=OFF
    BUILD_COMMAND ${CMAKE_MAKE_PROGRAM}
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(openal-soft)
extra_step(openal-soft)
