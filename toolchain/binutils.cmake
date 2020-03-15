ExternalProject_Add(binutils
    URL https://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.xz
    URL_HASH SHA512=2c7976939dcf5e8c5b7374cccd39bfe803b1bec73c6abfa0eb17c24e1942574c6bdb874c66a092a82adc443182eacd8a5a8001c19a76101f0c7ba40c27de0bbd
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
        --target=${TARGET_ARCH}
        --prefix=${CMAKE_INSTALL_PREFIX}
        --with-sysroot=${CMAKE_INSTALL_PREFIX}
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
