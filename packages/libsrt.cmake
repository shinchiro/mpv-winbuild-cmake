ExternalProject_Add(libsrt
    DEPENDS
        mbedtls
    GIT_REPOSITORY https://github.com/Haivision/srt.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am --3way ${CMAKE_CURRENT_SOURCE_DIR}/libsrt-*.patch
    CONFIGURE_COMMAND ${EXEC} cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DENABLE_STDCXX_SYNC=ON
        -DENABLE_APPS=OFF
        -DENABLE_SHARED=OFF
        -DUSE_ENCLIB=mbedtls
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libsrt)
cleanup(libsrt install)
