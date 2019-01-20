ExternalProject_Add(crossc
    DEPENDS
        spirv-cross
    GIT_REPOSITORY https://github.com/rossy/crossc.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE}
        CXX=${TARGET_ARCH}-g++
        AR=${TARGET_ARCH}-ar
    INSTALL_COMMAND ${MAKE}
        prefix=${MINGW_INSTALL_PREFIX}
        install-static
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(crossc remove-submodule
    DEPENDEES download update
    WORKING_DIRECTORY <SOURCE_DIR>
    COMMAND chmod 755 SPIRV-Cross
    COMMAND ${CMAKE_COMMAND} -E remove_directory SPIRV-Cross
    LOG 1
)

ExternalProject_Add_Step(crossc symlink-submodule
    DEPENDEES remove-submodule
    DEPENDERS build
    WORKING_DIRECTORY <SOURCE_DIR>
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_CURRENT_BINARY_DIR}/spirv-cross-prefix/src/spirv-cross SPIRV-Cross
    LOG 1
)

force_rebuild_git(crossc)
extra_step(crossc)
