ExternalProject_Add(gcc-binutils
    URL https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.xz
    URL_HASH SHA512=155f3ba14cd220102f4f29a4f1e5cfee3c48aa03b74603460d05afb73c70d6657a9d87eee6eb88bf13203fe6f31177a5c9addc04384e956e7da8069c8ecd20a6
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
        --target=${TARGET_ARCH}
        --prefix=${CMAKE_INSTALL_PREFIX}
        --with-sysroot=${CMAKE_INSTALL_PREFIX}
        --program-prefix=cross-
        --disable-multilib
        --disable-nls
        --disable-shared
        --disable-win32-registry
        --without-included-gettext
        --enable-lto
        --enable-plugins
        --enable-threads
    BUILD_COMMAND make -j${MAKEJOBS}
    INSTALL_COMMAND make install-strip
    LOG_DOWNLOAD 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

find_program(PKGCONFIG NAMES pkgconf)

ExternalProject_Add_Step(gcc-binutils basedirs
    DEPENDEES download
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/bin
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${PKGCONFIG} ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-pkg-config
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${PKGCONFIG} ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-pkgconf
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/${TARGET_ARCH}
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${MINGW_INSTALL_PREFIX} ${CMAKE_INSTALL_PREFIX}/mingw
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/${TARGET_ARCH}/lib
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/${TARGET_ARCH}/lib ${CMAKE_INSTALL_PREFIX}/${TARGET_ARCH}/lib64
    COMMENT "Setting up target directories and symlinks"
)

cleanup(gcc-binutils install)
