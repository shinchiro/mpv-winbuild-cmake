ExternalProject_Add(avisynth-headers
    GIT_REPOSITORY https://github.com/AviSynth/AviSynthPlus.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=Release
        -DHEADERS_ONLY=ON
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
    BUILD_COMMAND ""
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_INSTALL 1
)
force_rebuild_git(avisynth-headers)
extra_step(avisynth-headers)
