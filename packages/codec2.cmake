ExternalProject_Add(codec2
    GIT_REPOSITORY https://github.com/drowe67/codec2.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !unittest !raw !wav !stm32 !octave !doc !demo demo/CMakeLists.txt"
    GIT_PROGRESS TRUE
    GIT_REMOTE_NAME origin
    GIT_TAG main
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    COMMAND ${EXEC} echo > <SOURCE_DIR>/cmake/GetDependencies.cmake.in
    COMMAND ${EXEC} echo > <SOURCE_DIR>/demo/CMakeLists.txt
    COMMAND ${EXEC} sed -i [['/^add_executable.*$/d']] <SOURCE_DIR>/src/CMakeLists.txt
    COMMAND ${EXEC} sed -i [['/^target_link_libraries.*$/d']] <SOURCE_DIR>/src/CMakeLists.txt
    COMMAND ${EXEC} CONF=1 ${CMAKE_COMMAND} -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ${CMAKE_COMMAND} --install <BINARY_DIR>
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(codec2)
cleanup(codec2 install)
