ExternalProject_Add(svtav1
    GIT_REPOSITORY https://gitlab.com/AOMediaCodec/SVT-AV1.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
        -DENABLE_AVX512=ON
        -DBUILD_TESTING=OFF
        -DBUILD_ENC=ON
        -DSVT_AV1_LTO=OFF
        -DBUILD_APPS=OFF
        -DCMAKE_C_FLAGS='${CMAKE_C_FLAGS} -Dav1_cospi_arr_s32_data=svtav1_av1_cospi_arr_s32_data'
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(svtav1)
cleanup(svtav1 install)
