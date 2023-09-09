ExternalProject_Add(llvm-clang
    DEPENDS
        llvm-libcxx
        winpthreads
        gendef
        llvm-openmp
    DOWNLOAD_COMMAND ""
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    COMMENT "Dummy target to setup target toolchain"
)