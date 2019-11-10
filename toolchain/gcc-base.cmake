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
    URL ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/snapshots/9-20191109/gcc-9-20191109.tar.xz
    URL_HASH SHA512=7b2d1e804fb729ac687a6a565357782acb52443e4f8ac491aa7483a7bb6f4ff1692383dd46a8738c9b435db10635ca35e780ddb3541299513eab4230887808fb
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
