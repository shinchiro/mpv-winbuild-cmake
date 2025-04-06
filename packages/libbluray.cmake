ExternalProject_Add(libbluray
    DEPENDS
        libudfread
        freetype2
    GIT_REPOSITORY https://github.com/zhongflyTeam/libbluray.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --filter=tree:0"
    GIT_PROGRESS TRUE
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${autoreshit}
    COMMAND ${EXEC} CONF=1 ./configure
        ${autoshit_conf_args}
        --disable-examples
        --disable-doxygen-doc
        --disable-bdjava-jar
        --without-libxml2
        --without-fontconfig
        CFLAGS='-Ddec_init=libbluray_dec_init'
    BUILD_COMMAND ${MAKE} HIDE=1
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libbluray)
cleanup(libbluray install)
