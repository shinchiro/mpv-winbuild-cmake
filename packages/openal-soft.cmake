ExternalProject_Add(openal-soft
    DEPENDS
        libsdl2
    GIT_REPOSITORY https://github.com/kcat/openal-soft.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --filter=tree:0"
    GIT_PROGRESS TRUE
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 ${CMAKE_COMMAND} -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DLIBTYPE=STATIC
        -DALSOFT_UTILS=OFF
        -DALSOFT_EXAMPLES=OFF
        -DALSOFT_TESTS=OFF
        -DALSOFT_EAX=OFF
        -DALSOFT_INSTALL_UTILS=OFF
        -DALSOFT_INSTALL_CONFIG=OFF
        -DALSOFT_INSTALL_EXAMPLES=OFF
        -DALSOFT_INSTALL_HRTF_DATA=OFF
        -DALSOFT_INSTALL_AMBDEC_PRESETS=OFF
        -DALSOFT_BACKEND_PIPEWIRE=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
          COMMAND bash -c "echo 'Libs.private: -lole32 -luuid -lshlwapi' >> <BINARY_DIR>/openal.pc"
    INSTALL_COMMAND ${EXEC} ${CMAKE_COMMAND} --install <BINARY_DIR>
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(openal-soft)
cleanup(openal-soft install)
