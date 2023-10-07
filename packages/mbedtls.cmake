if(TARGET_CPU STREQUAL "x86_64")
    set(mbedtls_version "3.5.0")
    set(mbedtls_link "https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/v${mbedtls_version}.tar.gz")
    set(mbedtls_hash "BDEE0E3E45BBF360541306CAC0CC27E00402C7A46B9BDF2D24787D5107F008F2")
elseif(TARGET_CPU STREQUAL "i686")
    set(mbedtls_version "3.4.1")
    set(mbedtls_link "https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/v${mbedtls_version}.tar.gz")
    set(mbedtls_hash "A420FCF7103E54E775C383E3751729B8FB2DCD087F6165BEFD13F28315F754F5")
endif()

ExternalProject_Add(mbedtls
    URL ${mbedtls_link}
    URL_HASH SHA256=${mbedtls_hash}
    DOWNLOAD_DIR ${SOURCE_LOCATION}
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
    BUILD_COMMAND ${MAKE} -C <BINARY_DIR>
    INSTALL_COMMAND ${MAKE} -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

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
