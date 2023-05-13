ExternalProject_Add(llvm-clang
    DEPENDS
        llvm-libcxx
        winpthreads
        gendef
        # mingw-w64-crt
        # rustup
        llvm-openmp
    DOWNLOAD_COMMAND ""
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    COMMENT "Dummy target to setup target toolchain"
)