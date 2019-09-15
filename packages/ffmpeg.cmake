ExternalProject_Add(ffmpeg
    DEPENDS
        amf-headers
        nvcodec-headers
        bzip2
        game-music-emu
        gmp
        lame
        libressl
        libass
        libbluray
        libmodplug
        libpng
        libsoxr
        libvpx
        libwebp
        libzimg
        libmysofa
        opus
        speex
        vorbis
        x264
        xvidcore
        libxml2
        libmfx
        aom
        dav1d
    GIT_REPOSITORY https://github.com/FFmpeg/FFmpeg.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --cross-prefix=${TARGET_ARCH}-
        --prefix=${MINGW_INSTALL_PREFIX}
        --arch=${TARGET_CPU}
        --target-os=mingw32
        --target-exec=wine
        --pkg-config-flags=--static
        --enable-cross-compile
        --enable-runtime-cpudetect
        --enable-gpl
        --enable-version3
        --enable-nonfree
        --enable-avresample
        --enable-postproc
        --enable-avisynth
        --enable-gmp
        --enable-libass
        --enable-libbluray
        --enable-libfreetype
        --enable-libfribidi
        --enable-libgme
        --enable-libmodplug
        --enable-libmp3lame
        --enable-libopus
        --enable-libsoxr
        --enable-libspeex
        --enable-libvorbis
        --enable-libvpx
        --enable-libwebp
        --enable-libx264
        --enable-libaom
        --enable-libdav1d
        --enable-libxvid
        --enable-libzimg
        --enable-libtls
        --enable-libxml2
        --enable-libmysofa
        --enable-cuda
        --enable-cuvid
        --enable-nvdec
        --enable-nvenc
        --enable-libmfx
        --enable-amf
        --disable-decoder=libaom_av1
        "--extra-cflags=-DMODPLUG_STATIC"
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(ffmpeg)
extra_step(ffmpeg)
