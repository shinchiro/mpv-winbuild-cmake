ExternalProject_Add(libquvi_scripts
    DEPENDS lua
    GIT_REPOSITORY "git://repo.or.cz/libquvi-scripts.git"
    GIT_TAG v0.4.18
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --with-nsfw
        --with-fixme
        --with-nlfy
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
    BUILD_IN_SOURCE 1
)

ExternalProject_Add_Step(libquvi_scripts autogen
    DEPENDEES download update
    DEPENDERS configure
    COMMAND ${EXEC} ./autogen.sh -V
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)
