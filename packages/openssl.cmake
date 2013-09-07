if(${TARGET_CPU} MATCHES "x86_64")
    set(openssl_target "mingw64")
else()
    set(openssl_target "mingw")
endif()

ExternalProject_Add(openssl
    DEPENDS zlib libgcrypt
    URL "ftp://ftp.openssl.org/source/openssl-1.0.1e.tar.gz"
    URL_MD5 66bf6f10f060d561929de96f9dfe5b8c
    PATCH_COMMAND patch -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/openssl-1-winsock2.patch
        COMMAND patch -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/openssl-2-pod.patch
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
