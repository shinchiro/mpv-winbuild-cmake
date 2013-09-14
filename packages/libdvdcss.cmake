ExternalProject_Add(libdvdcss
    DEPENDS gcc
    GIT_REPOSITORY "git://git.videolan.org/libdvdcss"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-doc
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(libdvdcss force-update
    DEPENDEES download
    COMMAND git pull --rebase
    WORKING_DIRECTORY <SOURCE_DIR>
    ALWAYS 1
    LOG 1
)

ExternalProject_Add_Step(libdvdcss autoreconf
    DEPENDEES download update
    DEPENDERS configure
    COMMAND ${EXEC} autoreconf -fi
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)
