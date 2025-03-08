if(COMPILER_TOOLCHAIN STREQUAL "clang")
    set(vapoursynth_pkgconfig_libs "-lVapourSynth -Wl,-delayload=VapourSynth.dll")
    set(vapoursynth_script_pkgconfig_libs "-lVSScript -Wl,-delayload=VSScript.dll")
    if(CLANG_PACKAGES_LTO)
        set(cargo_lto_rustflags "CARGO_PROFILE_RELEASE_LTO=thin
        RUSTFLAGS='-Ctarget-cpu=${GCC_ARCH} -Cforce-frame-pointers=no -Ccontrol-flow-guard=yes -Clinker-plugin-lto=yes -Cforce-frame-pointers=no -Clto=thin -Cllvm-args=-fp-contract=fast -Zcombine-cgu=yes -Zfunction-sections=yes -Zhas-thread-local=yes -Zthreads=${CPU_COUNT}'")
    endif()
endif()

if(TARGET_CPU STREQUAL "x86_64")
    set(dlltool_image "i386:x86-64")
    set(openssl_target "mingw64")
    set(libvpx_target "x86_64-win64-gcc")
    set(xxhash_dispatch "-DDISPATCH=ON")
    set(nvcodec_headers "nvcodec-headers")
    set(ffmpeg_cuda "--enable-cuda-llvm --enable-cuvid --enable-nvdec --enable-nvenc --disable-ptx-compression")
    if(GCC_ARCH_HAS_AVX)
        set(aom_vpx_sse2avx
            COMMAND ${EXEC} sed -i [['/%macro INIT_XMM/,/%endmacro/ s/%assign avx_enabled 0/%assign avx_enabled 1/']] <SOURCE_DIR>/third_party/x86inc/x86inc.asm
        )
        set(novzeroupper
            COMMAND ${EXEC} sed -i [['s/%define vzeroupper_required .*/%define vzeroupper_required 0/']]
        )
    else()
        set(novzeroupper
            COMMAND true
        )
    endif()
elseif(TARGET_CPU STREQUAL "aarch64")
    set(dlltool_image "arm64")
    set(openssl_target "mingw-arm64")
    set(libvpx_target "arm64-win64-gcc")
    set(novzeroupper
        COMMAND true
    )
endif()

set(cmake_conf_args
    -GNinja
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
    -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
    -DBUILD_SHARED_LIBS=OFF
    -DBUILD_TESTING=OFF
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
)
set(meson_conf_args
    --cross-file=${MESON_CROSS}
)
set(autoshit_conf_args
    --host=${TARGET_ARCH}
    --prefix=${MINGW_INSTALL_PREFIX}
    --disable-shared
    --enable-static
)
set(autoreshit
    COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> <BINARY_DIR>
    COMMAND ${EXEC} autoreconf -fi
)
