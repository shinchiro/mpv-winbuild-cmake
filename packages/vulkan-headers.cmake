ExternalProject_Add(vulkan-headers
    SVN_REPOSITORY https://github.com/KhronosGroup/Vulkan-LoaderAndValidationLayers.git/trunk/include
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
)

ExternalProject_Add_Step(vulkan-headers copy
    DEPENDEES download
    COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/vulkan ${MINGW_INSTALL_PREFIX}/include/vulkan
    COMMENT "Copying vulkan headers"
)

force_rebuild_svn(vulkan-headers)
