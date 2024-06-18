ExternalProject_Add(gcc
    DEPENDS
        mingw-w64-headers
    URL https://mirrorservice.org/sites/sourceware.org/pub/gcc/snapshots/14-20240615/gcc-14-20240615.tar.xz
    # https://mirrorservice.org/sites/sourceware.org/pub/gcc/snapshots/13-20240309/sha512.sum
    URL_HASH SHA512=d8d757cfbedb7342443ce8de4439653537c46d25e552d88cea0ba9f7aa43ad14fb2b42a32a1dce5ae4eb2ac3849024f6b4e700f2c39330a00a65caa3f5fe29e7
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
        --target=${TARGET_ARCH}
        --prefix=${CMAKE_INSTALL_PREFIX}
        --libdir=${CMAKE_INSTALL_PREFIX}/lib
        --with-sysroot=${CMAKE_INSTALL_PREFIX}
        --program-prefix=cross-
        --disable-multilib
        --enable-languages=c,c++
        --disable-nls
        --disable-shared
        --disable-win32-registry
        --with-arch=${GCC_ARCH}
        --with-tune=generic
        --enable-threads=posix
        --without-included-gettext
        --enable-lto
        --enable-checking=release
        --disable-sjlj-exceptions
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
        rustup
    COMMAND ${MAKE}
    COMMAND ${MAKE} install-strip
    WORKING_DIRECTORY <BINARY_DIR>
    LOG 1
)

cleanup(gcc final)
