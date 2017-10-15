ExternalProject_Add(bzip2
    URL "http://bzip.org/1.0.6/bzip2-1.0.6.tar.gz"
    URL_MD5 00b516f4704d4a7cb50a1d97e6e8e15b
    PATCH_COMMAND patch -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/bzip2-1-fixes.patch
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE} libbz2.a
        PREFIX=${MINGW_INSTALL_PREFIX}
        CC=${TARGET_ARCH}-gcc
        AR=${TARGET_ARCH}-ar
        RANLIB=${TARGET_ARCH}-ranlib
    INSTALL_COMMAND install -d ${MINGW_INSTALL_PREFIX}/lib
        COMMAND install -m644 libbz2.a ${MINGW_INSTALL_PREFIX}/lib/
        COMMAND install -d ${MINGW_INSTALL_PREFIX}/include
        COMMAND install -m644 bzlib.h ${MINGW_INSTALL_PREFIX}/include/
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(bzip2)
