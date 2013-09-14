ExternalProject_Add(speex
    DEPENDS ogg
    GIT_REPOSITORY "http://git.xiph.org/speex.git"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-oggtest
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(speex force-update
    DEPENDEES download
    COMMAND git pull --rebase
    WORKING_DIRECTORY <SOURCE_DIR>
    ALWAYS 1
    LOG 1
)

ExternalProject_Add_Step(speex autogen
    DEPENDEES download update
    DEPENDERS configure
    COMMAND ${EXEC} ./autogen.sh -V
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)
