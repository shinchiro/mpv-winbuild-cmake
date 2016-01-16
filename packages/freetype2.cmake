configure_file(${CMAKE_CURRENT_SOURCE_DIR}/ft2exec.in ${CMAKE_CURRENT_BINARY_DIR}/ft2exec)

ExternalProject_Add(freetype2
    DEPENDS libpng zlib
    GIT_REPOSITORY git://git.sv.gnu.org/freetype/freetype2.git
    GIT_DEPTH 20
    GIT_TAG 2e09812c5121413fa29692a46b310983cb3de3e8
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${CMAKE_CURRENT_BINARY_DIR}/ft2exec <SOURCE_DIR>/configure
        --build=${HOST_ARCH}
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --without-harfbuzz
        --with-sysroot=${MINGW_INSTALL_PREFIX}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${MINGW_INSTALL_PREFIX}/bin/freetype-config ${CMAKE_INSTALL_PREFIX}/bin/freetype-config
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(freetype2)
force_rebuild_git(freetype2)
autogen(freetype2)
