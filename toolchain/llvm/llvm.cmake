ExternalProject_Add(llvm
    URL https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-16.0.4.tar.gz
    URL_HASH SHA256=10c3fe1757d2e4f1cd7745dc548ecf687680a71824ec81701c38524c2a0753e2
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    LIST_SEPARATOR ,
    CONFIGURE_COMMAND ${EXEC} cmake -H<SOURCE_DIR>/llvm -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLLVM_ENABLE_ASSERTIONS=OFF
        -DLLVM_ENABLE_PROJECTS='clang,lld'
        -DLLVM_TARGETS_TO_BUILD='ARM,AArch64,X86'
        -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
        -DLLVM_INCLUDE_TESTS=OFF
        -DLLVM_INCLUDE_BENCHMARKS=OFF
        -DCLANG_DEFAULT_RTLIB=compiler-rt
        -DCLANG_DEFAULT_UNWINDLIB=libunwind
        -DCLANG_DEFAULT_CXX_STDLIB=libc++
        -DCLANG_DEFAULT_LINKER=lld
        -DLLD_DEFAULT_LD_LLD_IS_MINGW=ON
        -DLLVM_LINK_LLVM_DYLIB=ON
        -DLLVM_ENABLE_LIBXML2=OFF
        -DLLVM_ENABLE_TERMINFO=OFF
        -DLLVM_TOOLCHAIN_TOOLS='llvm-as,llvm-ar,llvm-ranlib,llvm-objdump,llvm-rc,llvm-cvtres,llvm-nm,llvm-strings,llvm-readobj,llvm-dlltool,llvm-pdbutil,llvm-objcopy,llvm-strip,llvm-cov,llvm-profdata,llvm-addr2line,llvm-symbolizer,llvm-windres,llvm-ml,llvm-readelf,llvm-size,llvm-config'
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
get_property(LLVM_SRC TARGET llvm PROPERTY _EP_SOURCE_DIR)
