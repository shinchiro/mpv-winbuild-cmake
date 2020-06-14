ExternalProject_Add(libressl
    URL https://cloudflare.cdn.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.1.2.tar.gz
    URL_HASH SHA256=f88a2f7ea617149a34e40c022d9912963f00eaa6109af421317525e6c978d892
    PATCH_COMMAND patch -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/libressl-0001-remove-postfix-in-libs-name.patch
    CONFIGURE_COMMAND ${EXEC} cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DLIBRESSL_APPS=OFF
        -DLIBRESSL_TESTS=OFF
        -DBUILD_SHARED_LIBS=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

autoreconf(libressl)
extra_step(libressl)
