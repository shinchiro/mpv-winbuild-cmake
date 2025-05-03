configure_file(${CMAKE_CURRENT_SOURCE_DIR}/libmodplug.pc.in ${CMAKE_CURRENT_BINARY_DIR}/libmodplug.pc @ONLY)
ExternalProject_Add(libmodplug
    GIT_REPOSITORY https://github.com/Konstanty/libmodplug.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
            COMMAND bash -c "cp ${CMAKE_CURRENT_BINARY_DIR}/libmodplug.pc ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/libmodplug.pc"
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libmodplug)
cleanup(libmodplug install)
