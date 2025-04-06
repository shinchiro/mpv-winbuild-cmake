ExternalProject_Add(avisynth-headers
    GIT_REPOSITORY https://github.com/AviSynth/AviSynthPlus.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !distrib"
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    GIT_RESET 21fdc997f9724b994896ba5520ddf64d677976b3
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DHEADERS_ONLY=ON
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR> VersionGen
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
force_rebuild_git(avisynth-headers)
cleanup(avisynth-headers install)
