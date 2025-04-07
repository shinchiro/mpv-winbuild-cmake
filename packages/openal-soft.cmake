ExternalProject_Add(openal-soft
    DEPENDS
        libsdl2
    GIT_REPOSITORY https://github.com/kcat/openal-soft.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DLIBTYPE=STATIC
        -DALSOFT_UTILS=OFF
        -DALSOFT_EXAMPLES=OFF
        -DALSOFT_TESTS=OFF
        -DALSOFT_BACKEND_PIPEWIRE=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
          COMMAND bash -c "echo 'Libs.private: -lole32 -luuid -lshlwapi' >> <BINARY_DIR>/openal.pc"
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(openal-soft)
cleanup(openal-soft install)
