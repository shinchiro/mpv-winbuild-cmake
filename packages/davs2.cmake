ExternalProject_Add(davs2
    GIT_REPOSITORY https://github.com/pkuvcl/davs2.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cd <SOURCE_DIR>/build/linux && ./configure
        --host=${TARGET_ARCH}
        --cross-prefix=${TARGET_CPU}-w64-mingw32-
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-cli
    BUILD_COMMAND ${MAKE} -C <SOURCE_DIR>/build/linux
    INSTALL_COMMAND ${MAKE} -C <SOURCE_DIR>/build/linux install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(davs2 force-cleanup
    DEPENDEES build install
    COMMAND ${EXEC} git clean -dfx
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)

force_rebuild_git(davs2)
cleanup(davs2 force-cleanup)
