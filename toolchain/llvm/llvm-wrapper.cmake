find_program(PKGCONFIG NAMES pkgconf)
ExternalProject_Add(llvm-wrapper
    DOWNLOAD_COMMAND ""
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    COMMAND ${CMAKE_COMMAND} -E make_directory ${MINGW_INSTALL_PREFIX}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${MINGW_INSTALL_PREFIX}/lib
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-ar        ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-ar
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-ar        ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-llvm-ar
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-ar        ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-ranlib
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-ar        ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-llvm-ranlib
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-ar        ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-dlltool
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-objcopy   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-objcopy
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-objcopy   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-strip
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-size      ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-size
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-strings   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-strings
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-nm        ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-nm
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-readelf   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-readelf
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-rc        ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-windres
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/llvm-addr2line ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-addr2line
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${PKGCONFIG} ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-pkg-config
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${PKGCONFIG} ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-pkgconf
    INSTALL_COMMAND ""
    COMMENT "Setting up target directories and symlinks"
)

foreach(compiler clang++ g++ c++ clang gcc as)
    set(driver_mode "")
    set(clang_compiler "")
    set(linker "")
    
    if (compiler STREQUAL "g++" OR compiler STREQUAL "c++")
        set(driver_mode "--driver-mode=g++ -pthread")
        set(clang_compiler "clang++")
    elseif(compiler STREQUAL "clang++")
        set(driver_mode "--driver-mode=g++")
        set(clang_compiler "clang++")
        set(linker "-lc++abi")
    else()
        set(driver_mode "")
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

cleanup(llvm-wrapper install)
