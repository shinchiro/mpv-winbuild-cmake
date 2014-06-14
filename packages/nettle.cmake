ExternalProject_Add(nettle
    DEPENDS gmp
    GIT_REPOSITORY "https://git.lysator.liu.se/nettle/nettle.git"
    GIT_TAG "nettle_2.7.1_release_20130528" # required due to API/ABI breakage
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-openssl
    BUILD_COMMAND ${MAKE} EXEEXT_FOR_BUILD=.exe
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

# force_rebuild_git(nettle)
autoreconf(nettle)
