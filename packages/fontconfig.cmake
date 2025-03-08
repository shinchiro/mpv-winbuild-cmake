ExternalProject_Add(fontconfig
    DEPENDS
        libxml2
        freetype2
        zlib
        libiconv
    GIT_REPOSITORY https://github.com/zhongflyTeam/fontconfig.git
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG main
    GIT_CLONE_FLAGS "--depth=1 --filter=tree:0"
    GIT_PROGRESS TRUE
    PATCH_COMMAND ${EXEC} git am --3way ${CMAKE_CURRENT_SOURCE_DIR}/fontconfig-*.patch
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E rm -rf <SOURCE_DIR>/subprojects
    COMMAND ${EXEC} CONF=1 meson setup --reconfigure <BINARY_DIR> <SOURCE_DIR>
        ${meson_conf_args}
        -Diconv=enabled
        -Dxml-backend=libxml2
        -Ddoc=disabled
        -Dtests=disabled
        -Dtools=disabled
        -Dcache-build=disabled
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} meson install -C <BINARY_DIR> --only-changed --tags devel
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_PATCH 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(fontconfig)
cleanup(fontconfig install)
