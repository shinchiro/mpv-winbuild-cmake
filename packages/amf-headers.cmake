ExternalProject_Add(amf-headers
    SVN_REPOSITORY https://github.com/GPUOpen-LibrariesAndSDKs/AMF/trunk/amf/public/include
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/components ${MINGW_INSTALL_PREFIX}/include/AMF/components
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/core       ${MINGW_INSTALL_PREFIX}/include/AMF/core
    LOG_DOWNLOAD 1
)

cleanup(amf-headers install)
