ExternalProject_Add(ffmpeg
    DEPENDS
        bzip2
        dcadec
        fdk-aac
        game-music-emu
        lame
        libass
        libbluray
        libmodplug
        libpng
        libressl
        libvpx
        opencore-amr
        opus
        speex
        theora
        vorbis
        x264
        xvidcore
    #GIT_REPOSITORY git://github.com/FFmpeg/FFmpeg.git
    GIT_REPOSITORY git://git.videolan.org/ffmpeg.git
    GIT_DEPTH 1
    DOWNLOAD_NAME "ffmpeg"
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/ffmpeg-*.patch
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
    --enable-libass
    --enable-libbluray
    --enable-libdcadec
    --enable-libfdk-aac
    --enable-libfreetype
    --enable-libfribidi
    --enable-libgme
    --enable-libmodplug
    --enable-libmp3lame
    --enable-libopencore-amrnb
    --enable-libopencore-amrwb
    --enable-libopus
    --enable-libspeex
    --enable-libtheora
    --enable-libvorbis
    --enable-libvpx
    --enable-libx264
    --enable-libxvid
    --enable-openssl
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(ffmpeg)
force_rebuild_git(ffmpeg)
