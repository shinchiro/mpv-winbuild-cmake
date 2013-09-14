ExternalProject_Add(opus
    DEPENDS gcc
    GIT_REPOSITORY "git://git.xiph.org/opus.git"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(opus force-update
    DEPENDEES download
    COMMAND git pull --rebase
    WORKING_DIRECTORY <SOURCE_DIR>
    ALWAYS 1
    LOG 1
)

ExternalProject_Add_Step(opus autogen
    DEPENDEES download update
    DEPENDERS configure
    COMMAND ${EXEC} ./autogen.sh -V
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)
