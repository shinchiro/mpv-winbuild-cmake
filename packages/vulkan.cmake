ExternalProject_Add(vulkan
    GIT_REPOSITORY git://github.com/KhronosGroup/Vulkan-LoaderAndValidationLayers.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/vulkan-*.patch
    CONFIGURE_COMMAND ${EXEC} cmake
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        ##
        -DCMAKE_SYSTEM_NAME=Windows
        -DCMAKE_C_COMPILER=${TARGET_ARCH}-gcc
        -DCMAKE_CXX_COMPILER=${TARGET_ARCH}-g++
        -DCMAKE_RC_COMPILER=${TARGET_ARCH}-windres
        -DCMAKE_AR_COMPILER=${TARGET_ARCH}-ar
        -DCMAKE_RANLIB_COMPILER=${TARGET_ARCH}-ranlib
        -DCMAKE_C_FLAGS='${CMAKE_C_FLAGS} -D_WIN32_WINNT=0x0600 -D__STDC_FORMAT_MACROS'
        -DCMAKE_CXX_FLAGS='${CMAKE_CXX_FLAGS} -D__USE_MINGW_ANSI_STDIO -D__STDC_FORMAT_MACROS -fpermissive -D_WIN32_WINNT=0x0600'
        ##
        -DBUILD_ICD=OFF
        -DBUILD_DEMOS=OFF
        -DBUILD_TESTS=OFF
        -DBUILD_LAYERS=OFF
        -DBUILD_VKJSON=OFF
    BUILD_COMMAND ${MAKE}
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1

)

ExternalProject_Add_Step(vulkan manual-install
    DEPENDEES build
    WORKING_DIRECTORY <SOURCE_DIR>
    COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/include/vulkan ${MINGW_INSTALL_PREFIX}/include/vulkan
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/loader/libvulkan.a ${MINGW_INSTALL_PREFIX}/lib/libvulkan.a
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/loader/vulkan.pc ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/vulkan.pc
    COMMENT "Manual installing"
)

force_rebuild_git(vulkan)
extra_step(vulkan)
