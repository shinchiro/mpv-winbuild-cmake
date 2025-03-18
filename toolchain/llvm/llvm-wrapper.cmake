find_program(PKGCONFIG NAMES pkg-config)
find_program(NASM NAMES nasm)
ExternalProject_Add(llvm-wrapper
    DOWNLOAD_COMMAND ""
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    COMMAND ${CMAKE_COMMAND} -E make_directory ${MINGW_INSTALL_PREFIX}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${MINGW_INSTALL_PREFIX}/lib
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-ar        ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-ar
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-ranlib    ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-ranlib
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-dlltool   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-dlltool
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-objcopy   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-objcopy
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-strip     ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-strip
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-size      ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-size
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-nm        ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-nm
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-readelf   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-readelf
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-windres   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-windres
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-addr2line ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-addr2line
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-ar        ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-llvm-ar
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-ranlib    ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-llvm-ranlib
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-dlltool   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-llvm-dlltool
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-objcopy   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-llvm-objcopy
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-strip     ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-llvm-strip
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-size      ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-llvm-size
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-nm        ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-llvm-nm
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-readelf   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-llvm-readelf
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-windres   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-llvm-windres
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-addr2line ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-llvm-addr2line
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${PKGCONFIG}                                   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-pkg-config
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${PKGCONFIG}                                   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-pkgconf
    INSTALL_COMMAND ""
    COMMENT "Setting up target directories and symlinks"
)

foreach(compiler clang++ g++ c++ cc clang gcc as)
    if (compiler STREQUAL "g++" OR compiler STREQUAL "c++" OR compiler STREQUAL "clang++")
        set(clang_compiler "clang++")
    else()
        set(clang_compiler "clang")
    endif()
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/llvm/llvm-compiler.in
                   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-${compiler}
                   FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
                   @ONLY)
endforeach()

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/llvm/llvm-ld.in
               ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-ld
               FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
               @ONLY)

if(NASM AND GCC_ARCH_HAS_AVX)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/nasm.in
               ${CMAKE_INSTALL_PREFIX}/bin/nasm
               FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
               @ONLY)
else()
    file(REMOVE ${CMAKE_INSTALL_PREFIX}/bin/nasm)
endif()

cleanup(llvm-wrapper install)
