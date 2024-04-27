# worflows for clang compilation:
# mingw's header+crt -> compiler-rt builtins -> libcxx -> openmp
ExternalProject_Add(llvm-clang
    DEPENDS
        llvm-libcxx
        winpthreads
        gendef
        cppwinrt
    DOWNLOAD_COMMAND ""
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    COMMENT "Dummy target to setup target toolchain"
)

ExternalProject_Add(llvm-copy-builtin
    DOWNLOAD_COMMAND ""
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_ALWAYS 1
    BUILD_COMMAND ""
    INSTALL_COMMAND bash -c "mkdir -p $(${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-gcc -print-runtime-dir)"
            COMMAND bash -c "cp ${MINGW_INSTALL_PREFIX}/lib/libclang* $(${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-gcc -print-runtime-dir)"
    COMMENT "Copy libclang_rt.builtins*.a to runtime dir"
)
