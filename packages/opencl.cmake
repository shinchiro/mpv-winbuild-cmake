ExternalProject_Add(opencl
    DEPENDS
        opencl-header
    GIT_REPOSITORY https://github.com/KhronosGroup/OpenCL-ICD-Loader.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --filter=tree:0"
    GIT_PROGRESS TRUE
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG main
    CONFIGURE_COMMAND ${EXEC} CONF=1 ${CMAKE_COMMAND} -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DOPENCL_ICD_LOADER_HEADERS_DIR=${MINGW_INSTALL_PREFIX}/include
        -DOPENCL_ICD_LOADER_BUILD_SHARED_LIBS=OFF
        -DOPENCL_ICD_LOADER_PIC=ON
        -DOPENCL_ICD_LOADER_BUILD_TESTING=OFF
        -DENABLE_OPENCL_LAYERINFO=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ${CMAKE_COMMAND} --install <BINARY_DIR>
            COMMAND ${CMAKE_COMMAND} -E copy ${MINGW_INSTALL_PREFIX}/lib/OpenCL.a ${MINGW_INSTALL_PREFIX}/lib/libOpenCL.a
            COMMAND bash -c "echo 'Libs.private: -lole32 -lshlwapi -lcfgmgr32' >> ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/OpenCL.pc"
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
force_rebuild_git(opencl)
cleanup(opencl install)
