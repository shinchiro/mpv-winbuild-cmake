ExternalProject_Add(llvm-mingw
  URL https://github.com/mstorsjo/llvm-mingw/releases/download/20231128/llvm-mingw-20231128-ucrt-ubuntu-20.04-x86_64.tar.xz
  DOWNLOAD_DIR ${SOURCE_LOCATION}
  PATCH_COMMAND
        COMMAND bash -c "rm -rf <SOURCE_DIR>/bin/${TARGET_ARCH}-{clang,clang++,gcc,g++,c++,ld}"
        COMMAND bash -c "rm -rf <SOURCE_DIR>/${TARGET_ARCH}/lib/*.dll.a"
        COMMAND bash -c "cp <SOURCE_DIR>/${TARGET_ARCH}/lib/libc++.a <SOURCE_DIR>/${TARGET_ARCH}/lib/libstdc++.a"
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
          COMMAND bash -c "rm -rf ${CMAKE_INSTALL_PREFIX}/{bin,include,lib,share}"
          COMMAND bash -c "mkdir -p ${CMAKE_INSTALL_PREFIX}/{bin,include,lib,share}"
          COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/lib ${CMAKE_INSTALL_PREFIX}/lib
          COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/share ${CMAKE_INSTALL_PREFIX}/share
          COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/include ${CMAKE_INSTALL_PREFIX}/include
          COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/bin ${CMAKE_INSTALL_PREFIX}/bin
          COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/${TARGET_ARCH}
          COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/${TARGET_ARCH} ${CMAKE_INSTALL_PREFIX}/${TARGET_ARCH}
          COMMAND bash -c "rm -rf <TMP_DIR>"
  LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
  ALWAYS 1
)
cleanup(llvm-mingw install)