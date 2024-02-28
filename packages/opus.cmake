get_property(src_opus_dnn TARGET opus-dnn PROPERTY _EP_SOURCE_DIR)
ExternalProject_Add(opus
    DEPENDS
        opus-dnn
    GIT_REPOSITORY https://github.com/xiph/opus.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_REMOTE_NAME origin
    GIT_TAG main
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    COMMAND bash -c "cp ${src_opus_dnn}/*.h ${src_opus_dnn}/*.c <SOURCE_DIR>/dnn"
    COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --buildtype=release
        --default-library=static
        -Dhardening=false
        -Dextra-programs=disabled
        -Dtests=disabled
        -Ddocs=disabled
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
            COMMAND bash -c "rm -rf ${src_opus_dnn}/models" # To save space
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(opus)
force_meson_configure(opus)
cleanup(opus install)
