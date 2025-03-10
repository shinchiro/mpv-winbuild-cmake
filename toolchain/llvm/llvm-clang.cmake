# worflows for clang compilation:
# mingw's header+crt -> compiler-rt builtins -> libcxx -> openmp
ExternalProject_Add(llvm-clang
    DEPENDS
        llvm-libcxx
        llvm-compiler-rt-builtin
        mingw-w64-crt
        mingw-w64-winpthreads
        mingw-w64-gendef
        cppwinrt
    DOWNLOAD_COMMAND ""
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    COMMENT "Dummy target to setup target toolchain"
)
cleanup(llvm-clang install)
