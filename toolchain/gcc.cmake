if(${TARGET_CPU} MATCHES "x86_64")
    set(gcc_arch "x86-64")
    set(exception "--enable-seh-exceptions")
else()
    set(gcc_arch "i686")
    set(exception "--enable-dw2-exceptions")
endif()

ExternalProject_Add(gcc
    DEPENDS
        mingw-w64-headers
    URL https://mirrorservice.org/sites/sourceware.org/pub/gcc/snapshots/11-20220429/gcc-11-20220429.tar.xz
    URL_HASH SHA512=218b2bc9cba09829d76f695fa3d0db8ea4c15b4af3cb8364eb65adc6c8e0dd80765f0b7ae36e111ad0355bb2883599413f9d93feb12d880a4baa7c499d47758c
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
        --target=${TARGET_ARCH}
        --prefix=${CMAKE_INSTALL_PREFIX}
        --libdir=${CMAKE_INSTALL_PREFIX}/lib
        --with-sysroot=${CMAKE_INSTALL_PREFIX}
        --disable-multilib
        --enable-languages=c,c++
        --disable-nls
        --disable-shared
        --disable-win32-registry
        --with-arch=${gcc_arch}
        --with-tune=generic
        --enable-threads=posix
        --without-included-gettext
        --enable-lto
        --enable-checking=release
        ${exception}
    BUILD_COMMAND make -j${MAKEJOBS} all-gcc
    INSTALL_COMMAND make install-strip-gcc
    STEP_TARGETS download install
    LOG_DOWNLOAD 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(gcc final
    DEPENDS
        mingw-w64-crt
        winpthreads
        gendef
    COMMAND ${MAKE}
    COMMAND ${MAKE} install-strip
    WORKING_DIRECTORY <BINARY_DIR>
    LOG 1
)

cleanup(gcc final)
