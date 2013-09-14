ExternalProject_Add(opencore-amr
    DEPENDS gcc
    GIT_REPOSITORY "git://git.code.sf.net/p/opencore-amr/code"
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/opencore-amr-*.patch
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(opencore-amr force-update
    DEPENDEES download
    COMMAND git pull --rebase
    WORKING_DIRECTORY <SOURCE_DIR>
    ALWAYS 1
    LOG 1
)

ExternalProject_Add_Step(opencore-amr autoreconf
    DEPENDEES download update
    DEPENDERS configure
    COMMAND ${EXEC} autoreconf -fi
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)
