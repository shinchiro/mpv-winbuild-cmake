if(${TARGET_CPU} MATCHES "i686")
    set(HWY_CMAKE_SSE2 "-DHWY_CMAKE_SSE2=ON")
endif()

ExternalProject_Add(highway
    GIT_REPOSITORY https://github.com/google/highway.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DCMAKE_GNUtoMS=OFF
        -DHWY_CMAKE_ARM7=OFF
        -DHWY_ENABLE_CONTRIB=OFF
        -DHWY_ENABLE_EXAMPLES=OFF
        -DHWY_ENABLE_INSTALL=ON
        -DHWY_WARNINGS_ARE_ERRORS=OFF
        ${HWY_CMAKE_SSE2}
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(highway)
cleanup(highway install)
