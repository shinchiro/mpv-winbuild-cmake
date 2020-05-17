ExternalProject_Add(glslang
    GIT_REPOSITORY https://github.com/KhronosGroup/glslang.git
    GIT_SHALLOW 1
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/glslang-*.patch
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1
)

force_rebuild_git(glslang)
extra_step(glslang)
