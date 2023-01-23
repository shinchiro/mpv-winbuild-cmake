ExternalProject_Add(fribidi
    GIT_REPOSITORY https://github.com/fribidi/fribidi.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} meson <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --buildtype=release
        --default-library=static
        -Dcpp_args='-DFRIBIDI_LIB_STATIC'
        -Ddocs=false
        -Dbin=false
        -Dtests=false
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(fribidi)
force_meson_configure(fribidi)
cleanup(fribidi install)
