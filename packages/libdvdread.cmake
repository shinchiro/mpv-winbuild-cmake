ExternalProject_Add(libdvdread
    DEPENDS libdvdcss
    GIT_REPOSITORY "git://git.videolan.org/libdvdread.git"
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/libdvdread-*.patch
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --enable-libdvdcss
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
        COMMAND ${CMAKE_COMMAND} -E create_symlink ${MINGW_INSTALL_PREFIX}/bin/dvdread-config ${CMAKE_INSTALL_PREFIX}/bin/dvdread-config
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(libdvdread force-update
    DEPENDEES download
    COMMAND git pull --rebase
    WORKING_DIRECTORY <SOURCE_DIR>
    ALWAYS 1
    LOG 1
)

ExternalProject_Add_Step(libdvdread autogen
    DEPENDEES download update patch
    DEPENDERS configure
    COMMAND ${EXEC} ./autogen.sh -V
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)
