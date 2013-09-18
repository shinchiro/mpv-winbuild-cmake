ExternalProject_Add(binutils
    URL "ftp://sourceware.org/pub/binutils/snapshots/binutils-2.23.90.tar.bz2"
    URL_MD5 b278da68838a5548e671ad835576a8fe
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
        --target=${TARGET_ARCH}
        --prefix=${CMAKE_INSTALL_PREFIX}
        --with-sysroot=${CMAKE_INSTALL_PREFIX}
        --disable-multilib
        --disable-nls
        --disable-shared
    BUILD_COMMAND make -j${MAKEJOBS}
    INSTALL_COMMAND make install
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
    DEPENDS binutils
    SVN_REPOSITORY "http://svn.code.sf.net/p/mingw-w64/code/trunk/mingw-w64-headers"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --enable-sdk=all
    INSTALL_COMMAND make install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

# ExternalProject_Add(gcc-mpfr
#     PREFIX gcc-prefix
#     STAMP_DIR gcc-prefix/src/gcc-mpfr-stamp
#     SOURCE_DIR gcc-prefix/src/gcc/mpfr
#     URL "ftp://ftp.gnu.org/pub/gnu/mpfr/mpfr-3.1.2.tar.bz2"
#     CONFIGURE_COMMAND ""
#     BUILD_COMMAND ""
#     INSTALL_COMMAND ""
#     LOG_DOWNLOAD 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
# )
#
# ExternalProject_Add(gcc-mpc
#     PREFIX gcc-prefix
#     STAMP_DIR gcc-prefix/src/gcc-mpc-stamp
#     SOURCE_DIR gcc-prefix/src/gcc/mpc
#     URL "ftp://ftp.gnu.org/pub/gnu/mpc/mpc-1.0.1.tar.gz"
#     CONFIGURE_COMMAND ""
#     BUILD_COMMAND ""
#     INSTALL_COMMAND ""
#     LOG_DOWNLOAD 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
# )
#
# ExternalProject_Add(gcc-gmp
#     PREFIX gcc-prefix
#     STAMP_DIR gcc-prefix/src/gcc-gmp-stamp
#     SOURCE_DIR gcc-prefix/src/gcc/gmp
#     URL "ftp://ftp.gnu.org/pub/gnu/gmp/gmp-5.1.2.tar.bz2"
#     CONFIGURE_COMMAND ""
#     BUILD_COMMAND ""
#     INSTALL_COMMAND ""
#     LOG_DOWNLOAD 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
# )

ExternalProject_Add(gcc-base
    PREFIX gcc-prefix
    STAMP_DIR gcc-prefix/src/gcc-stamp
    SOURCE_DIR gcc-prefix/src/gcc
    BINARY_DIR gcc-prefix/src/gcc-build
    DEPENDS mingw-w64-headers # gcc-mpfr gcc-mpc gcc-gmp
    URL "ftp://ftp.gwdg.de/pub/misc/gcc/releases/gcc-4.8.1/gcc-4.8.1.tar.bz2"
    URL_MD5 3b2386c114cd74185aa3754b58a79304
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
    BUILD_COMMAND make -j${MAKEJOBS} all-gcc
    INSTALL_COMMAND make install-gcc
    LOG_DOWNLOAD 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

# ExternalProject_Add_Step(gcc-base unpack-deps
#     DEPENDERS configure
#     DEPENDEES download
#     COMMAND tar xf <SOURCE_DIR>/../gmp-*.tar.bz2
#     COMMAND mv gmp-* gmp
#     COMMAND tar xf <SOURCE_DIR>/../mpc-*.tar.gz
#     COMMAND mv mpc-* mpc
#     COMMAND tar xf <SOURCE_DIR>/../mpfr-*.tar.bz2
#     COMMAND mv mpfr-* mpfr
#     WORKING_DIRECTORY <SOURCE_DIR>
#     COMMENT "Unpacking GCC dependencies"
#     LOG 1
# )

ExternalProject_Add(mingw-w64-crt
    DEPENDS gcc-base
    SVN_REPOSITORY "http://svn.code.sf.net/p/mingw-w64/code/trunk/mingw-w64-crt"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --with-sysroot=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add(gcc
    DEPENDS mingw-w64-crt
    SOURCE_DIR gcc-prefix/src
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_BUILD 1 LOG_INSTALL 1
)
