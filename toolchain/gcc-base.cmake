if(${TARGET_CPU} MATCHES "x86_64")
    set(gcc_arch "x86-64")
    set(exception "--enable-seh-exceptions")
else()
    set(gcc_arch "i686")
    set(exception "--enable-dw2-exceptions")
endif()

ExternalProject_Add(gcc-base
    DEPENDS
        mingw-w64-headers
    PREFIX gcc-prefix
    STAMP_DIR gcc-prefix/src/gcc-stamp
    SOURCE_DIR gcc-prefix/src/gcc
    BINARY_DIR gcc-prefix/src/gcc-build
    URL ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/snapshots/10-20200822/gcc-10-20200822.tar.xz
    URL_HASH SHA512=bedcba6cc049007ff3874c84a359f6d678cb38e28000cdb06b729293e697aab01f5e6f670222c37aecdc797d5a84691499e1b46eb5983ca539494a7eb37cbf94
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
    LOG_DOWNLOAD 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
