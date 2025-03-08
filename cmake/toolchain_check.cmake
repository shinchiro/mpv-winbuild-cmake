if(COMPILER_TOOLCHAIN STREQUAL "clang")
    if(LLVM_ENABLE_LTO STREQUAL "Thin")
        set(llvm_lto "-flto=thin -fwhole-program-vtables -fsplit-lto-unit")
    elseif(LLVM_ENABLE_LTO STREQUAL "Full")
        set(llvm_lto "-flto=full -fwhole-program-vtables -fsplit-lto-unit")
    endif()
    if(LLVM_ENABLE_PGO STREQUAL "GEN")
        set(llvm_pgo "-fprofile-generate=${LLVM_PROFILE_DATA_DIR} -fprofile-update=atomic -mllvm -vp-counters-per-site=8")
    elseif(LLVM_ENABLE_PGO STREQUAL "CSGEN")
        set(llvm_pgo "-fcs-profile-generate=${LLVM_PROFILE_DATA_DIR} -fprofile-update=atomic -mllvm -vp-counters-per-site=8 -fprofile-use=${LLVM_PROFDATA_FILE}")
    elseif(LLVM_ENABLE_PGO STREQUAL "USE")
        set(llvm_pgo "-fprofile-use=${LLVM_PROFDATA_FILE}")
    endif()
    include(CheckCCompilerFlag)
    check_c_compiler_flag("-mtls-dialect=gnu2" TLSDESC_AVAILABLE)
    check_c_compiler_flag("-Wa,-msse2avx -mno-vzeroupper" SSE2AVX_AVAILABLE)
    check_c_compiler_flag("-Wa,--crel,--allow-experimental-crel" CREL_AVAILABLE)
    set(llvm_cflags "-march=native -fno-ident -fno-temp-file -fno-math-errno -ftls-model=local-exec")
    if(TLSDESC_AVAILABLE)
        set(llvm_cflags "${llvm_cflags} -mtls-dialect=gnu2")
    endif()
    if(SSE2AVX_AVAILABLE)
        set(llvm_cflags "${llvm_cflags} -Wa,-msse2avx -mno-vzeroupper")
    endif()
    if(CREL_AVAILABLE)
        set(llvm_cflags "${llvm_cflags} -Wa,--crel,--allow-experimental-crel")
    endif()
endif()

if(TARGET_CPU STREQUAL "x86_64")
    set(ld_m_flag "i386pep")
    set(crt_lib "--disable-lib32 --enable-lib64")
elseif(TARGET_CPU STREQUAL "aarch64")
    set(ld_m_flag "arm64pe")
    set(crt_lib "--disable-lib32 --disable-lib64 --enable-libarm64")
endif()

set(cmake_conf_args
    -GNinja
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
    -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
    -DBUILD_SHARED_LIBS=OFF
    -DBUILD_TESTING=OFF
)
