configure_file(${CMAKE_CURRENT_SOURCE_DIR}/ft2exec.in ${CMAKE_CURRENT_BINARY_DIR}/ft2exec)

ExternalProject_Add(freetype2
    DEPENDS libpng zlib libpng
    GIT_REPOSITORY "git://git.sv.gnu.org/freetype/freetype2.git"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${CMAKE_CURRENT_BINARY_DIR}/ft2exec <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --with-sysroot=${MINGW_INSTALL_PREFIX}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
        COMMAND ${CMAKE_COMMAND} -E create_symlink ${MINGW_INSTALL_PREFIX}/bin/freetype-config ${CMAKE_INSTALL_PREFIX}/bin
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(freetype2 force-update
    DEPENDEES download
    COMMAND git pull --rebase
    WORKING_DIRECTORY <SOURCE_DIR>
    ALWAYS 1
    LOG 1
)

ExternalProject_Add_Step(freetype2 autogen
    DEPENDEES download update
    DEPENDERS configure
    COMMAND chmod +x autogen.sh
    COMMAND ${EXEC} ./autogen.sh
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)
