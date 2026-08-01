set(PC_VERSION "72")
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/vapoursynth.pc.in ${CMAKE_CURRENT_BINARY_DIR}/vapoursynth.pc @ONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/vapoursynth-script.pc.in ${CMAKE_CURRENT_BINARY_DIR}/vapoursynth-script.pc @ONLY)

ExternalProject_Add(vapoursynth
    GIT_REPOSITORY https://github.com/vapoursynth/vapoursynth.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /include !include/cython"
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG master
    GIT_RESET e46204429041e95a881b61eedddd46c08f9a307c # 72
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/include ${MINGW_INSTALL_PREFIX}/include/vapoursynth
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/vapoursynth.pc ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/vapoursynth.pc
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/vapoursynth-script.pc ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/vapoursynth-script.pc
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_INSTALL 1
)

force_rebuild_git(vapoursynth)
cleanup(vapoursynth install)