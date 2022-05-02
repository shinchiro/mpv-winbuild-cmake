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
    GIT_SHALLOW 1
    GIT_REMOTE_NAME origin
    GIT_TAG main
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DBUILD_SHARED_LIBS=OFF
        -DCMAKE_BUILD_TYPE=Release
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
        -DCMAKE_CXX_FLAGS='${CMAKE_CXX_FLAGS} -DHWY_COMPILE_ONLY_SCALAR' # fix crash on AVX2 proc (64bit)
        -DCMAKE_C_FLAGS='${CMAKE_C_FLAGS} -DHWY_COMPILE_ONLY_SCALAR'
    BUILD_COMMAND ${MAKE} -C <BINARY_DIR>
    INSTALL_COMMAND ${MAKE} -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

get_property(src_brotli TARGET brotli PROPERTY _EP_SOURCE_DIR)

ExternalProject_Add_Step(libjxl symlink
    DEPENDEES download
    WORKING_DIRECTORY <SOURCE_DIR>/third_party
    COMMAND rm -r brotli
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${src_brotli} brotli
    COMMENT "Symlinking brotli"
)

ExternalProject_Add_Step(libjxl manual-install
    DEPENDEES build
    WORKING_DIRECTORY <BINARY_DIR>
    COMMAND echo "Cflags.private: -DJXL_STATIC_DEFINE"  | tee -a lib/libjxl.pc lib/libjxl_threads.pc > /dev/null
    COMMAND echo "Libs.private: -lstdc++"               | tee -a lib/libjxl.pc lib/libjxl_threads.pc > /dev/null
)

ExternalProject_Add_Step(libjxl fix-lib
    DEPENDEES install
    WORKING_DIRECTORY ${MINGW_INSTALL_PREFIX}/lib
    COMMAND mv libjxl-static.a          libjxl.a
    COMMAND mv libjxl_dec-static.a      libjxl_dec.a
    COMMAND mv libjxl_threads-static.a  libjxl_threads.a
)

force_rebuild_git(libjxl)
cleanup(libjxl fix-lib)
