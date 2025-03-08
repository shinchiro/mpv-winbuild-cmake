ExternalProject_Add(lcms2
    DEPENDS
        libjpeg
        zlib
    GIT_REPOSITORY https://github.com/mm2/Little-CMS.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !testbed testbed/meson.build !plugins/*/testbed plugins/*/testbed/meson.build"
    GIT_PROGRESS TRUE
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    COMMAND ${EXEC} echo > <SOURCE_DIR>/testbed/meson.build
    COMMAND ${EXEC} echo > <SOURCE_DIR>/plugins/threaded/testbed/meson.build
    COMMAND ${EXEC} echo > <SOURCE_DIR>/plugins/fast_float/testbed/meson.build
    COMMAND ${EXEC} sed -i [['s/is_visual_studio =.*/is_visual_studio = true/g']] <SOURCE_DIR>/meson.build
    COMMAND ${EXEC} CONF=1 meson setup --reconfigure <BINARY_DIR> <SOURCE_DIR>
        ${meson_conf_args}
        -Dfastfloat=true
        -Dthreaded=true
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} meson install -C <BINARY_DIR> --only-changed --tags devel
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(lcms2)
cleanup(lcms2 install)
