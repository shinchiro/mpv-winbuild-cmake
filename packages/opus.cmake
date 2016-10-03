ExternalProject_Add(opus
    GIT_REPOSITORY https://github.com/xiph/opus.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/autogen.sh
    COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/opus-*.patch
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(opus clean
    DEPENDERS update
    WORKING_DIRECTORY <SOURCE_DIR>
    COMMAND git clean -dfx
    ALWAYS 1
    LOG 1
)

clean_build_dir(opus)
force_rebuild_git(opus)
