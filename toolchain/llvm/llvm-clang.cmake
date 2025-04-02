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
