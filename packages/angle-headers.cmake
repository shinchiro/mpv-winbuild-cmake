ExternalProject_Add(angle-headers
    SVN_REPOSITORY https://github.com/google/angle/trunk/include
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/EGL ${MINGW_INSTALL_PREFIX}/include/EGL
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/KHR ${MINGW_INSTALL_PREFIX}/include/KHR
    LOG_DOWNLOAD 1
)

extra_step(angle-headers)
