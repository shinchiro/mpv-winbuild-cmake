if(${TARGET_CPU} MATCHES "x86_64")
    set(openssl_target "mingw64")
else()
    set(openssl_target "mingw")
endif()

ExternalProject_Add(openssl
    DEPENDS zlib libgcrypt
    URL "https://github.com/openssl/openssl/archive/OpenSSL_1_0_2a.tar.gz"
    URL_HASH SHA256=1966e463640f1bd099e2da77620c9e3b9ff986f426d83b328f2719e328ad079f
    PATCH_COMMAND patch -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/openssl-1-no-docs.patch
    CONFIGURE_COMMAND ${EXEC} CC=${TARGET_ARCH}-gcc <SOURCE_DIR>/Configure
        ${openssl_target}
        zlib
        no-shared
        no-capieng
        --prefix=${MINGW_INSTALL_PREFIX}
    # parallel make confuses GNU make’s job server here
    BUILD_COMMAND ${MAKE} -j1 CC=${TARGET_ARCH}-gcc "AR='${TARGET_ARCH}-ar rcu'" RANLIB=${TARGET_ARCH}-ranlib
    INSTALL_COMMAND ${MAKE} -j1 CC=${TARGET_ARCH}-gcc "AR='${TARGET_ARCH}-ar rcu'" RANLIB=${TARGET_ARCH}-ranlib install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
