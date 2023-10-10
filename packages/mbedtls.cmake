ExternalProject_Add(mbedtls
    GIT_REPOSITORY https://github.com/Mbed-TLS/mbedtls.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG development
    CONFIGURE_COMMAND ${EXEC} cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_BUILD_TYPE=Release
        -DENABLE_PROGRAMS=OFF
        -DENABLE_TESTING=OFF
        -DGEN_FILES=ON
        -DUSE_STATIC_MBEDTLS_LIBRARY=ON
        -DUSE_SHARED_MBEDTLS_LIBRARY=OFF
        -DINSTALL_MBEDTLS_HEADERS=ON
        -DMBEDTLS_FATAL_WARNINGS=OFF
        -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} ${MBEDTLS_AES}
    BUILD_COMMAND ${MAKE} -C <BINARY_DIR>
    INSTALL_COMMAND ${MAKE} -C <BINARY_DIR> install
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
Version: ${mbedtls_version}
Libs: -L\${libdir} -lmbedtls -lmbedx509 -lmbedcrypto
Libs.private: -lbcrypt -lws2_32
Cflags: -I\${includedir}
")
