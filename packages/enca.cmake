ExternalProject_Add(enca
    DEPENDS libiconv
    GIT_REPOSITORY "git://github.com/nijel/enca.git"
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/enca-*.patch
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(enca force-update
    DEPENDEES download
    COMMAND git reset --hard
    COMMAND git pull --rebase
    WORKING_DIRECTORY <SOURCE_DIR>
    ALWAYS 1
    LOG 1
)

ExternalProject_Add_Step(enca autoreconf
    DEPENDEES download update patch
    DEPENDERS configure
    COMMAND ${EXEC} autoreconf -fi
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)

ExternalProject_Add_Step(enca fix-configure
    DEPENDEES patch
    DEPENDERS configure
    COMMAND ${CMAKE_COMMAND} -E echo "wine iconvcap.exe" > iconvcap
    COMMAND chmod +x iconvcap
    WORKING_DIRECTORY <BINARY_DIR>
)
