ExternalProject_Add(aom
    GIT_REPOSITORY https://aomedia.googlesource.com/aom
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --sparse --filter=tree:0"
    GIT_PROGRESS TRUE
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !doc !examples"
    GIT_REMOTE_NAME origin
    GIT_TAG main
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 ${CMAKE_COMMAND} -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DENABLE_EXAMPLES=OFF
        -DENABLE_DOCS=OFF
        -DENABLE_TOOLS=OFF
        -DENABLE_NASM=ON
        -DENABLE_TESTS=OFF
        -DENABLE_TESTDATA=OFF
        -DCONFIG_UNIT_TESTS=0
        -DCONFIG_AV1_DECODER=0
        -DENABLE_SVE=OFF
        -DENABLE_SVE2=OFF
    ${aom_vpx_sse2avx}
    ${novzeroupper} <SOURCE_DIR>/third_party/x86inc/x86inc.asm
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ${CMAKE_COMMAND} --install <BINARY_DIR>
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(aom)
cleanup(aom install)
