ExternalProject_Add(vulkan-header
    GIT_REPOSITORY https://github.com/KhronosGroup/Vulkan-Headers.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
    BUILD_COMMAND ""
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_INSTALL 1
)

force_rebuild_git(vulkan-header)
extra_step(vulkan-header)

ExternalProject_Add(vulkan
    DEPENDS vulkan-header
    GIT_REPOSITORY https://github.com/KhronosGroup/Vulkan-Loader.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/vulkan-*.patch
    CONFIGURE_COMMAND ${EXEC} cmake
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DVULKAN_HEADERS_INSTALL_DIR=${MINGW_INSTALL_PREFIX}
        ##
        -DCMAKE_SYSTEM_NAME=Windows
        -DCMAKE_C_COMPILER=${TARGET_ARCH}-gcc
        -DCMAKE_CXX_COMPILER=${TARGET_ARCH}-g++
        -DCMAKE_RC_COMPILER=${TARGET_ARCH}-windres
        -DCMAKE_AR_COMPILER=${TARGET_ARCH}-ar
        -DCMAKE_RANLIB_COMPILER=${TARGET_ARCH}-ranlib
        -DCMAKE_ASM-ATT_COMPILER=${TARGET_ARCH}-as
        -DCMAKE_C_FLAGS='${CMAKE_C_FLAGS} -D_WIN32_WINNT=0x0600 -D__STDC_FORMAT_MACROS'
        -DCMAKE_CXX_FLAGS='${CMAKE_CXX_FLAGS} -D__USE_MINGW_ANSI_STDIO -D__STDC_FORMAT_MACROS -fpermissive -D_WIN32_WINNT=0x0600'
        ##
        -DBUILD_TESTS=OFF
        -DENABLE_STATIC_LOADER=ON
    BUILD_IN_SOURCE 1
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(vulkan)
extra_step(vulkan)
