ExternalProject_Add(mbedtls
    GIT_REPOSITORY https://github.com/Mbed-TLS/mbedtls.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    PATCH_COMMAND ${EXEC} git am --3way ${CMAKE_CURRENT_SOURCE_DIR}/mbedtls-*.patch
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG master
    GIT_RESET 1ec69067fa1351427f904362c1221b31538c8b57 # v3.5.0
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
        -DENABLE_PROGRAMS=OFF
        -DENABLE_TESTING=OFF
        -DGEN_FILES=ON
        -DUSE_STATIC_MBEDTLS_LIBRARY=ON
        -DUSE_SHARED_MBEDTLS_LIBRARY=OFF
        -DINSTALL_MBEDTLS_HEADERS=ON
        -DMBEDTLS_FATAL_WARNINGS=OFF
        -DCMAKE_C_FLAGS='${CMAKE_C_FLAGS} -mpclmul -msse2 -maes' # needed for i686's target
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(mbedtls)
cleanup(mbedtls install)

set(mbedtls_pc ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/mbedtls.pc)
file(WRITE ${mbedtls_pc}
"prefix=${MINGW_INSTALL_PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include

Name: mbedtls
Description: mbedtls
Version: 3.5.0
Libs: -L\${libdir} -lmbedtls -lmbedx509 -lmbedcrypto
Libs.private: -lbcrypt -lws2_32
Cflags: -I\${includedir}
")
