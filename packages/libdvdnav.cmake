ExternalProject_Add(libdvdnav
    DEPENDS libdvdread
    GIT_REPOSITORY "git://git.videolan.org/libdvdnav.git"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
        COMMAND ${CMAKE_COMMAND} -E create_symlink ${MINGW_INSTALL_PREFIX}/bin/dvdnav-config ${CMAKE_INSTALL_PREFIX}/bin/dvdnav-config
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(libdvdnav force-update
    DEPENDEES download
    COMMAND git pull --rebase
    WORKING_DIRECTORY <SOURCE_DIR>
    ALWAYS 1
    LOG 1
)

ExternalProject_Add_Step(libdvdnav autoreconf
    DEPENDEES download update
    DEPENDERS configure
    COMMAND ${EXEC} autoreconf -fi
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)
