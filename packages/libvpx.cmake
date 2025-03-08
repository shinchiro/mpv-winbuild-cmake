ExternalProject_Add(libvpx
    GIT_REPOSITORY https://github.com/webmproject/libvpx.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --filter=tree:0"
    GIT_PROGRESS TRUE
    GIT_REMOTE_NAME origin
    GIT_TAG main
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 CROSS=${TARGET_ARCH}- <SOURCE_DIR>/configure
        --extra-cflags='-fno-asynchronous-unwind-tables'
        --target=${libvpx_target}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-examples
        --disable-docs
        --disable-tools
        --disable-unit-tests
        --disable-decode-perf-tests
        --disable-encode-perf-tests
        --as=yasm
        --enable-debug
        --enable-vp9-highbitdepth
    COMMAND ${EXEC} sed -i [['/HAVE_PTHREAD_H/d']] <BINARY_DIR>/vpx_config.h
    COMMAND ${EXEC} sed -i [['/HAVE_PTHREAD_H/d']] <BINARY_DIR>/libs-${libvpx_target}.mk
    COMMAND ${EXEC} sed -i [['/extralibs/d']] <BINARY_DIR>/libs-${libvpx_target}.mk
    ${aom_vpx_sse2avx}
    ${novzeroupper} <SOURCE_DIR>/third_party/x86inc/x86inc.asm
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libvpx)
cleanup(libvpx install)
