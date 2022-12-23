if(${TARGET_CPU} MATCHES "x86_64")
    set(arch "${GCC_ARCH}")
    set(exception "--enable-seh-exceptions")
else()
    set(arch "i686")
    set(exception "--enable-dw2-exceptions")
endif()

ExternalProject_Add(gcc
    DEPENDS
        mingw-w64-headers
    URL https://mirrorservice.org/sites/sourceware.org/pub/gcc/snapshots/12-20221217/gcc-12-20221217.tar.xz
    # https://mirrorservice.org/sites/sourceware.org/pub/gcc/snapshots/12-20221217/sha512.sum
    URL_HASH SHA512=64a0f8f9b8ea07b1dcd0807c4fdae9de5cb0f1986c02a81798a47a116539695ce2408bdcea723ac55d892ccc0435319e7e7f4e472f2692407a77205669563d67
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=54412
    PATCH_COMMAND ${EXEC} curl -sL https://salsa.debian.org/mingw-w64-team/gcc-mingw-w64/-/raw/5e7d749d80e47d08e34a17971479d06cd423611e/debian/patches/vmov-alignment.patch | patch -p2
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
        --with-arch=${arch}
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
