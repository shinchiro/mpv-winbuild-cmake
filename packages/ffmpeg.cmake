ExternalProject_Add(ffmpeg
    DEPENDS
        amf-headers
        avisynth-headers
        nvcodec-headers
        bzip2
        gmp
        lame
        mbedtls
        libssh
        libsrt
        libass
        libbluray
        libmodplug
        libpng
        libsoxr
        libbs2b
        libvpx
        libwebp
        libzimg
        libmysofa
        fontconfig
        harfbuzz
        opus
        speex
        vorbis
        x264
        ${ffmpeg_x265}
        xvidcore
        libxml2
        libvpl
        libopenmpt
        libjxl
        shaderc
        libplacebo
        libzvbi
        libaribcaption
        aom
        rav1e
        dav1d
        vapoursynth
        uavs3d
        davs2
    GIT_REPOSITORY https://github.com/FFmpeg/FFmpeg.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --cross-prefix=${TARGET_ARCH}-
        --prefix=${MINGW_INSTALL_PREFIX}
        --arch=${TARGET_CPU}
        --target-os=mingw32
        --pkg-config-flags=--static
        --enable-cross-compile
        --enable-runtime-cpudetect
        ${ffmpeg_hardcoded_tables}
        --enable-gpl
        --enable-version3
        --enable-nonfree
        --enable-postproc
        --enable-avisynth
        --enable-vapoursynth
        --enable-gmp
        --enable-libass
        --enable-libbluray
        --enable-libfreetype
        --enable-libfribidi
        --enable-libfontconfig
        --enable-libharfbuzz
        --enable-libmodplug
        --enable-libopenmpt
        --enable-libmp3lame
        --enable-libopus
        --enable-libsoxr
        --enable-libspeex
        --enable-libvorbis
        --enable-libbs2b
        --enable-libvpx
        --enable-libwebp
        --enable-libx264
        --enable-libx265
        --enable-libaom
        --enable-librav1e
        --enable-libdav1d
        --enable-libdavs2
        --enable-libuavs3d
        --enable-libxvid
        --enable-libzimg
        --enable-mbedtls
        --enable-libxml2
        --enable-libmysofa
        --enable-libssh
        --enable-libsrt
        --enable-libvpl
        --enable-libjxl
        --enable-libplacebo
        --enable-libshaderc
        --enable-libzvbi
        --enable-libaribcaption
        --enable-cuda-llvm
        --enable-cuvid
        --enable-nvdec
        --enable-nvenc
        --enable-amf
        --disable-doc
        --disable-vaapi
        --disable-vdpau
        --disable-videotoolbox
        --disable-decoder=libaom_av1
        "--extra-libs='${ffmpeg_extra_libs}'" # -lstdc++ / -lc++ needs by libjxl and shaderc
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(ffmpeg)
cleanup(ffmpeg install)
