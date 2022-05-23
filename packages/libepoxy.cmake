ExternalProject_Add(libepoxy
    GIT_REPOSITORY https://github.com/anholt/libepoxy.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SHALLOW 1
    PATCH_COMMAND ${EXEC} curl -s https://patch-diff.githubusercontent.com/raw/anholt/libepoxy/pull/265.patch | git am -3 --whitespace=fix
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} meson <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --buildtype=release
        --default-library=static
        -Dtests=false
        -Ddocs=false
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libepoxy)
force_meson_configure(libepoxy)
cleanup(libepoxy install)
