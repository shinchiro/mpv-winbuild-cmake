ExternalProject_Add(fdk-aac
    GIT_REPOSITORY https://github.com/mstorsjo/fdk-aac.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --filter=tree:0"
    GIT_PROGRESS TRUE
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 ${CMAKE_COMMAND} -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DFDK_AAC_INSTALL_CMAKE_CONFIG_MODULE=ON
        -DFDK_AAC_INSTALL_PKGCONFIG_MODULE=ON
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ${CMAKE_COMMAND} --install <BINARY_DIR>
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(fdk-aac)
cleanup(fdk-aac install)
