if(${TARGET_CPU} MATCHES "x86_64")
    set(openssl_target "mingw64")
else()
    set(openssl_target "mingw")
endif()

ExternalProject_Add(openssl
    DEPENDS zlib libgcrypt
    URL "https://www.openssl.org/source/openssl-1.0.1j.tar.gz"
    URL_HASH SHA1=cff86857507624f0ad42d922bb6f77c4f1c2b819
    PATCH_COMMAND patch -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/openssl-1-fixes.patch
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
