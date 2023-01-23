ExternalProject_Add(libzimg
    DEPENDS
        graphengine
    GIT_REPOSITORY https://github.com/sekrit-twc/zimg.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

get_property(src_graphengine TARGET graphengine PROPERTY _EP_SOURCE_DIR)

ExternalProject_Add_Step(libzimg symlink
    DEPENDEES download update patch
    DEPENDERS configure
    WORKING_DIRECTORY <SOURCE_DIR>
    COMMAND rm -rf graphengine
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${src_graphengine} graphengine
    COMMENT "Symlinking graphengine"
)

force_rebuild_git(libzimg)
autogen(libzimg)
cleanup(libzimg install)
