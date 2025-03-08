get_property(src_opus_dnn TARGET opus-dnn PROPERTY _EP_SOURCE_DIR)
ExternalProject_Add(opus
    DEPENDS
        opus-dnn
    GIT_REPOSITORY https://github.com/xiph/opus.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_PROGRESS TRUE
    GIT_REMOTE_NAME origin
    GIT_TAG main
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    COMMAND bash -c "cp ${src_opus_dnn}/*.h ${src_opus_dnn}/*.c <SOURCE_DIR>/dnn"
    COMMAND ${EXEC} CONF=1 meson setup --reconfigure <BINARY_DIR> <SOURCE_DIR>
        ${meson_conf_args}
        -Dhardening=false
        -Ddeep-plc=enabled
        -Ddred=enabled
        -Dosce=enabled
        -Dintrinsics=enabled
        -Dfloat-approx=true
        -Dextra-programs=disabled
        -Dtests=disabled
        -Ddocs=disabled
    BUILD_COMMAND ${EXEC} HIDE=1 ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} meson install -C <BINARY_DIR> --only-changed --tags devel
            COMMAND ${CMAKE_COMMAND} -E rm -rf ${src_opus_dnn}/models
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(opus)
cleanup(opus install)
