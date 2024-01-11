get_property(src_libjpeg TARGET libjpeg PROPERTY _EP_SOURCE_DIR)
ExternalProject_Add(libjxl
    DEPENDS
        lcms2
        libpng
        zlib
        libjpeg
        brotli
        highway
    GIT_REPOSITORY https://github.com/libjxl/libjxl.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_REMOTE_NAME origin
    GIT_TAG main
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    COMMAND bash -c "rm -rf <SOURCE_DIR>/third_party/libjpeg-turbo"
    COMMAND bash -c "ln -s ${src_libjpeg} <SOURCE_DIR>/third_party/libjpeg-turbo"
    COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DJPEGXL_STATIC=ON
        -DBUILD_TESTING=OFF
        -DJPEGXL_EMSCRIPTEN=OFF
        -DJPEGXL_BUNDLE_LIBPNG=OFF
        -DJPEGXL_ENABLE_TOOLS=OFF
        -DJPEGXL_ENABLE_VIEWERS=OFF
        -DJPEGXL_ENABLE_DOXYGEN=OFF
        -DJPEGXL_ENABLE_EXAMPLES=OFF
        -DJPEGXL_ENABLE_MANPAGES=OFF
        -DJPEGXL_ENABLE_JNI=OFF
        -DJPEGXL_ENABLE_SKCMS=OFF
        -DJPEGXL_ENABLE_PLUGINS=OFF
        -DJPEGXL_ENABLE_DEVTOOLS=OFF
        -DJPEGXL_ENABLE_BENCHMARK=OFF
        -DJPEGXL_ENABLE_SJPEG=OFF
        -DJPEGXL_ENABLE_AVX512=ON
        -DJPEGXL_ENABLE_AVX512_ZEN4=ON
        -DJPEGXL_ENABLE_AVX512_SPR=ON
        -DJPEGXL_FORCE_SYSTEM_LCMS2=ON
        -DJPEGXL_FORCE_SYSTEM_BROTLI=ON
        -DJPEGXL_FORCE_SYSTEM_HWY=ON
        -DCMAKE_CXX_FLAGS='${CMAKE_CXX_FLAGS} ${libjxl_unaligned_vector}'
        -DCMAKE_C_FLAGS='${CMAKE_C_FLAGS}     ${libjxl_unaligned_vector}'
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libjxl)
cleanup(libjxl install)
