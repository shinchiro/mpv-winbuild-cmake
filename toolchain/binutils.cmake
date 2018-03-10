ExternalProject_Add(binutils
    URL https://sourceware.org/pub/binutils/releases/binutils-2.30.tar.xz
    URL_HASH SHA256=6e46b8aeae2f727a36f0bd9505e405768a72218f1796f0d09757d45209871ae6
    PATCH_COMMAND patch -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/binutils-0001-remove-provide-qualifiers.patch
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
