ExternalProject_Add(fribidi
    GIT_REPOSITORY https://github.com/fribidi/fribidi.git
    # GIT_SHALLOW 1
    GIT_TAG f503e576c8345dd32d7438569346d6ca9aa50044
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} meson <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --buildtype=release
        --default-library=static
        -Ddeprecated=false
        -Ddocs=false
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(fribidi)
force_meson_configure(fribidi)
extra_step(fribidi)
