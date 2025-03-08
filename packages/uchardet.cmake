ExternalProject_Add(uchardet
    GIT_REPOSITORY https://github.com/zhongflyTeam/uchardet.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !doc !test */CMakeLists.txt"
    GIT_PROGRESS TRUE
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    COMMAND ${EXEC} echo > <SOURCE_DIR>/doc/CMakeLists.txt
    COMMAND ${EXEC} echo > <SOURCE_DIR>/test/CMakeLists.txt
    COMMAND ${EXEC} CONF=1 ${CMAKE_COMMAND} -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DBUILD_STATIC=ON
        -DBUILD_BINARY=OFF
        -DTARGET_ARCHITECTURE=${TARGET_CPU_FAMILY}
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ${CMAKE_COMMAND} --install <BINARY_DIR>
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(uchardet)
cleanup(uchardet install)
