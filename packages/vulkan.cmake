ExternalProject_Add(vulkan
    DEPENDS vulkan-header
    GIT_REPOSITORY https://github.com/KhronosGroup/Vulkan-Loader.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG main
    PATCH_COMMAND ${EXEC} git am --3way ${CMAKE_CURRENT_SOURCE_DIR}/vulkan-*.patch
    CONFIGURE_COMMAND ${EXEC} cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DVULKAN_HEADERS_INSTALL_DIR=${MINGW_INSTALL_PREFIX}
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DBUILD_TESTS=OFF
        -DENABLE_WERROR=OFF
        -DBUILD_STATIC_LOADER=ON
        -DCMAKE_C_FLAGS='${CMAKE_C_FLAGS} -D_WIN32_WINNT=0x0600 -D__STDC_FORMAT_MACROS -DSTRSAFE_NO_DEPRECATE -Dparse_number=cjson_parse_number'
        -DCMAKE_CXX_FLAGS='${CMAKE_CXX_FLAGS} -D__USE_MINGW_ANSI_STDIO -D__STDC_FORMAT_MACROS -fpermissive -D_WIN32_WINNT=0x0600'
    BUILD_COMMAND ${MAKE} -C <BINARY_DIR>
    INSTALL_COMMAND ${MAKE} -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(vulkan copy-wdk-headers
    DEPENDEES download
    DEPENDERS configure
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/toolchain/mingw-headers/d3dkmthk.h <SOURCE_DIR>/loader/d3dkmthk.h
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/toolchain/mingw-headers/d3dukmdt.h <SOURCE_DIR>/loader/d3dukmdt.h
    COMMENT "Copying extra mingw headers"
)

force_rebuild_git(vulkan)
cleanup(vulkan install)
