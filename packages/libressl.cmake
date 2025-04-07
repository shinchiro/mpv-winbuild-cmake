ExternalProject_Add(libressl
    URL https://cdn.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.1.5.tar.gz
    URL_HASH SHA256=2c13ddcec5081c0e7ba7f93d8370a91911173090f1922007e1d90de274500494
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    PATCH_COMMAND patch -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/libressl-0001-remove-postfix-in-libs-name.patch
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DLIBRESSL_APPS=OFF
        -DLIBRESSL_TESTS=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(libressl install)
