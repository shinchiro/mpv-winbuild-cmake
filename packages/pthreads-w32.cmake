ExternalProject_Add(pthreads-w32
    DEPENDS gcc
    URL "ftp://sourceware.org/pub/pthreads-win32/pthreads-w32-2-9-1-release.tar.gz"
    URL_MD5 36ba827d6aa0fa9f9ae740a35626e2e3
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE} -j1 GC-static CROSS=${TARGET_ARCH}-
    INSTALL_COMMAND install -m644 libpthreadGC2.a ${MINGW_INSTALL_PREFIX}/lib/libpthread.a
        COMMAND install -m644 pthread.h ${MINGW_INSTALL_PREFIX}/include/
        COMMAND install -m644 sched.h ${MINGW_INSTALL_PREFIX}/include/
        COMMAND install -m644 semaphore.h ${MINGW_INSTALL_PREFIX}/include/
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_BUILD 1 LOG_INSTALL 1
)
