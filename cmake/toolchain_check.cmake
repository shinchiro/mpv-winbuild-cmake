if(COMPILER_TOOLCHAIN STREQUAL "gcc")
    set(gcc_install "gcc-install")
    set(binutils "gcc-binutils")
    set(gcc_wrapper "gcc-wrapper")
    set(opt "-O3")
elseif(COMPILER_TOOLCHAIN STREQUAL "clang")
    set(llvm_wrapper "llvm-wrapper")
    set(llvm_libcxx "llvm-libcxx")
    set(cfguard "--enable-cfguard")
    set(opt "-O3")
    if(LLVM_ENABLE_CCACHE)
        set(llvm_ccache "-DLLVM_CCACHE_BUILD=ON -DLLVM_CCACHE_DIR=${LLVM_CCACHE_DIR} -DLLVM_CCACHE_MAXSIZE=${LLVM_CCACHE_MAXSIZE}")
    endif()
    if(LLVM_ENABLE_LTO STREQUAL "Thin")
        set(llvm_lto "-flto=thin -fwhole-program-vtables -fsplit-lto-unit")
    elseif(LLVM_ENABLE_LTO STREQUAL "Full")
        set(llvm_lto "-flto=full -fwhole-program-vtables -fsplit-lto-unit")
    endif()
    if(LLVM_ENABLE_PGO STREQUAL "GEN")
        set(llvm_pgo "-fprofile-generate=${LLVM_PROFILE_DATA_DIR} -fprofile-update=atomic")
    elseif(LLVM_ENABLE_PGO STREQUAL "CSGEN")
        set(llvm_pgo "-fcs-profile-generate=${LLVM_PROFILE_DATA_DIR} -fprofile-update=atomic -fprofile-use=${LLVM_PROFDATA_FILE}")
    elseif(LLVM_ENABLE_PGO STREQUAL "USE")
        set(llvm_pgo "-fprofile-use=${LLVM_PROFDATA_FILE}")
    endif()
    if(LLVM_ENABLE_2MB_ALIGN)
        set(llvm_linker_flags "-Xlinker -zcommon-page-size=2097152 -Xlinker -zmax-page-size=2097152 -Xlinker -zseparate-loadable-segments")
    endif()
endif()

if(TARGET_CPU STREQUAL "x86_64")
    set(crt_lib "--disable-lib32 --enable-lib64")
    set(LIBOMP_ASMFLAGS_M64 "-DLIBOMP_ASMFLAGS=-m64")
    set(M_TUNE "generic")
    set(cfi "-mguard=cf")
    if (GCC_ARCH STREQUAL "x86-64")
        unset(cfi)
        unset(opt)
    endif()
elseif(TARGET_CPU STREQUAL "i686")
    set(crt_lib "--enable-lib32 --disable-lib64")
    set(M_TUNE "generic")
    unset(opt)
elseif(TARGET_CPU STREQUAL "aarch64")
    set(crt_lib "--disable-lib32 --disable-lib64 --enable-libarm64")
    set(M_TUNE "generic")
    set(cfi "-mguard=cf")
endif()
