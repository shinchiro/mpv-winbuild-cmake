ExternalProject_Add(gcc-wrapper
    DOWNLOAD_COMMAND ""
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    COMMAND ${CMAKE_COMMAND} -E make_directory ${MINGW_INSTALL_PREFIX}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${MINGW_INSTALL_PREFIX}/lib
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/cross-as        ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-as
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/cross-ar        ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-ar
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/cross-ranlib    ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-ranlib
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/cross-dlltool   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-dlltool
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/cross-objcopy   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-objcopy
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/cross-strip     ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-strip
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/cross-size      ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-size
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/cross-strings   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-strings
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/cross-nm        ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-nm
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/cross-readelf   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-readelf
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/cross-windres   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-windres
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/cross-addr2line ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-addr2line
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${PKGCONFIG} ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-pkg-config
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${PKGCONFIG} ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-pkgconf
    INSTALL_COMMAND ""
    COMMENT "Setting up target directories and symlinks"
)

foreach(compiler g++ c++ cpp gcc)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/gcc/gcc-compiler.in
                   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-${compiler}
                   FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
                   @ONLY)
endforeach()

foreach(linker ld ld.bfd)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/gcc/gcc-ld.in
                   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-${linker}
                   FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
                   @ONLY)
endforeach()

cleanup(gcc-wrapper install)
