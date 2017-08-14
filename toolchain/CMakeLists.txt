if(${TARGET_CPU} MATCHES "x86_64")
    set(gcc_arch "x86-64")
    set(exception "--enable-seh-exceptions")
else()
    set(gcc_arch "i686")
    set(exception "--enable-dw2-exceptions")
endif()

ExternalProject_Add(binutils
    URL "http://ftp.gnu.org/gnu/binutils/binutils-2.29.tar.bz2"
    URL_HASH SHA256=29a29549869039aad75fdf507ac30366da5ad0b974fbff4a8e7148dbf4f40ebf
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
        --target=${TARGET_ARCH}
        --prefix=${CMAKE_INSTALL_PREFIX}
        --with-sysroot=${CMAKE_INSTALL_PREFIX}
        --disable-multilib
        --disable-nls
        --disable-shared
    BUILD_COMMAND make -j${MAKEJOBS}
    INSTALL_COMMAND make install-strip
    LOG_DOWNLOAD 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

find_program(PKGCONFIG NAMES pkg-config)

ExternalProject_Add_Step(binutils basedirs
    DEPENDEES download
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/bin
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${PKGCONFIG} ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-pkg-config
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/${TARGET_ARCH}
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/${TARGET_ARCH} ${CMAKE_INSTALL_PREFIX}/mingw
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/${TARGET_ARCH}/lib
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/${TARGET_ARCH}/lib ${CMAKE_INSTALL_PREFIX}/${TARGET_ARCH}/lib64
    COMMENT "Setting up target directories and symlinks"
)

ExternalProject_Add(mingw-w64-headers
    PREFIX mingw-w64-prefix
    STAMP_DIR mingw-w64-prefix/src/mingw-w64-stamp
    SOURCE_DIR mingw-w64-prefix/src/mingw-w64
    BINARY_DIR mingw-w64-prefix/src/mingw-w64-headers-build
    DEPENDS binutils
    GIT_REPOSITORY git://github.com/mirror/mingw-w64.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/mingw-w64-*.patch
    CONFIGURE_COMMAND <SOURCE_DIR>/mingw-w64-headers/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --enable-sdk=all
        --enable-secure-api
    BUILD_COMMAND ""
    INSTALL_COMMAND make install-strip
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(mingw-w64-headers autoreconf
    DEPENDEES download update patch
    DEPENDERS configure
    COMMAND ${EXEC} autoreconf -fi
    WORKING_DIRECTORY <SOURCE_DIR>/mingw-w64-crt
    LOG 1
)

ExternalProject_Add(gcc-base
    PREFIX gcc-prefix
    STAMP_DIR gcc-prefix/src/gcc-stamp
    SOURCE_DIR gcc-prefix/src/gcc
    BINARY_DIR gcc-prefix/src/gcc-build
    DEPENDS mingw-w64-headers
    URL ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-7.2.0/gcc-7.2.0.tar.xz
    URL_HASH SHA512=f853cd6530b4055d8d8289da74687cb4c6d5f363598d386332d31852b581bac76c3adb7d61889edec3b779f63d8646f0122840f12965ce4a4389ba535dbbb6e1
    PATCH_COMMAND patch -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/gcc-0016-disable-weak-refs-in-libstdc++.patch
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
        ${exception}
    BUILD_COMMAND make -j${MAKEJOBS} all-gcc
    INSTALL_COMMAND make install-strip-gcc
    LOG_DOWNLOAD 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add(mingw-w64-crt
    PREFIX mingw-w64-prefix
    SOURCE_DIR mingw-w64-prefix/src
    DEPENDS gcc-base
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/mingw-w64/mingw-w64-crt/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --with-sysroot=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install-strip
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add(winpthreads
    PREFIX mingw-w64-prefix
    SOURCE_DIR mingw-w64-prefix/src
    DEPENDS mingw-w64-crt
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/mingw-w64/mingw-w64-libraries/winpthreads/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --enable-static
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install-strip
    LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add(gcc
    DEPENDS winpthreads
    SOURCE_DIR gcc-prefix/src
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install-strip
    LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add(gendef
    PREFIX mingw-w64-prefix
    SOURCE_DIR mingw-w64-prefix/src
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/mingw-w64/mingw-w64-tools/gendef/configure
        --prefix=${MINGW_INSTALL_PREFIX}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install-strip
    LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
