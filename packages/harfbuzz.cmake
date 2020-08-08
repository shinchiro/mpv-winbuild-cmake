ExternalProject_Add(harfbuzz
    DEPENDS
        freetype2
        libpng
    GIT_REPOSITORY https://github.com/harfbuzz/harfbuzz.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} meson <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --buildtype=release
        --default-library=static
        -Dicu=disabled
        -Dglib=disabled
        -Dgobject=disabled
        -Dtests=disabled
        -Ddocs=disabled
        -Dbenchmark=disabled
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(harfbuzz)
force_meson_configure(harfbuzz)
extra_step(harfbuzz)
