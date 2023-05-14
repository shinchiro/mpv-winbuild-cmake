ExternalProject_Add(amf-headers
    GIT_REPOSITORY https://github.com/GPUOpen-LibrariesAndSDKs/AMF.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set amf/public/include"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/amf/public/include/components  ${MINGW_INSTALL_PREFIX}/include/AMF/components
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/amf/public/include/core        ${MINGW_INSTALL_PREFIX}/include/AMF/core
    LOG_DOWNLOAD 1 LOG_UPDATE 1
)

force_rebuild_git(amf-headers)
cleanup(amf-headers install)
