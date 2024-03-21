if(COMPILER_TOOLCHAIN STREQUAL "gcc")
    set(vapoursynth_pkgconfig_libs "-lvapoursynth")
    set(vapoursynth_script_pkgconfig_libs "-lvsscript")
    set(vapoursynth_manual_install_copy_lib COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libvsscript.a ${MINGW_INSTALL_PREFIX}/lib/libvsscript.a
                                            COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libvapoursynth.a ${MINGW_INSTALL_PREFIX}/lib/libvapoursynth.a)
    set(ffmpeg_extra_libs "-lstdc++")
    set(libjxl_unaligned_vector "-Wa,-muse-unaligned-vector-move") # fix crash on AVX2 proc (64bit) due to unaligned stack memory
    set(mpv_copy_debug COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.debug ${CMAKE_CURRENT_BINARY_DIR}/mpv-debug/mpv.debug)
    set(mpv_add_debuglink COMMAND ${EXEC} ${TARGET_ARCH}-objcopy --only-keep-debug <BINARY_DIR>/mpv.exe <BINARY_DIR>/mpv.debug
                          COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <BINARY_DIR>/mpv.exe
                          COMMAND ${EXEC} ${TARGET_ARCH}-objcopy --add-gnu-debuglink=<BINARY_DIR>/mpv.debug <BINARY_DIR>/mpv.exe
                          COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <BINARY_DIR>/mpv.com
                          COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <BINARY_DIR>/libmpv-2.dll)
elseif(COMPILER_TOOLCHAIN STREQUAL "clang")
    set(vapoursynth_pkgconfig_libs "-lVapourSynth -Wl,-delayload=VapourSynth.dll")
    set(vapoursynth_script_pkgconfig_libs "-lVSScript -Wl,-delayload=VSScript.dll")
    set(vapoursynth_manual_install_copy_lib COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/VSScript.lib ${MINGW_INSTALL_PREFIX}/lib/VSScript.lib
                                            COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/VapourSynth.lib ${MINGW_INSTALL_PREFIX}/lib/VapourSynth.lib)
    set(ffmpeg_extra_libs "-lc++")
    set(ffmpeg_hardcoded_tables "--enable-hardcoded-tables")
    set(mpv_lto_mode "-Db_lto_mode=thin")
    set(mpv_copy_debug COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.pdb ${CMAKE_CURRENT_BINARY_DIR}/mpv-debug/mpv.pdb)
    if(CLANG_PACKAGES_LTO)
        set(cargo_lto_rustflags "CARGO_PROFILE_RELEASE_LTO=thin
                                 RUSTFLAGS='-C linker-plugin-lto -C embed-bitcode -C lto=thin'")
        set(ffmpeg_lto "--enable-lto=thin")
        set(x264_lto "--enable-lto")
        if(GCC_ARCH_HAS_AVX)
            set(zlib_lto "-DFNO_LTO_AVAILABLE=OFF")
            # prevent zlib-ng from adding -fno-lto
        endif()
    endif()
endif()

if(TARGET_CPU STREQUAL "x86_64")
    set(dlltool_image "i386:x86-64")
    set(vulkan_asm "-DUSE_GAS=ON")
elseif(TARGET_CPU STREQUAL "i686")
    set(dlltool_image "i386")
    set(vulkan_asm "-DUSE_MASM=OFF")
elseif(TARGET_CPU STREQUAL "aarch64")
    set(dlltool_image "arm64")
    set(vulkan_asm "-DUSE_GAS=ON")
endif()
