ExternalProject_Add(game-music-emu
    DEPENDS
        zlib
    GIT_REPOSITORY https://github.com/libgme/game-music-emu.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --filter=tree:0"
    GIT_PROGRESS TRUE
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 ${CMAKE_COMMAND} -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DGME_BUILD_TESTING=OFF
        -DGME_BUILD_EXAMPLES=OFF
        -DGME_ENABLE_UBSAN=OFF
        -DCMAKE_DISABLE_FIND_PACKAGE_SDL2=ON
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ${CMAKE_COMMAND} --install <BINARY_DIR>
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(game-music-emu)
cleanup(game-music-emu install)
