set(FFMPEG_GIT_TAG "n7.1.3" CACHE STRING "FFmpeg git tag for AVS patch compatibility")
set(FFMPEG_PATCH_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/patches/ffmpeg")
set(CAVS_DRA_GIT_URL "https://github.com/maliwen2015/ffmpeg_cavs_dra.git")
set(CAVS_DRA_GIT_REF "abae276fed97ce08928f25c8f5e03fd915687f54")
set(CAVS_DRA_PATCH_NAME "ffmpeg-7.1.2_cavs_dra.patch")
set(CAVS_DRA_CACHE_DIR "${CMAKE_CURRENT_BINARY_DIR}/cavs_dra")
set(CAVS_DRA_PATCH_PATH "${CAVS_DRA_CACHE_DIR}/${CAVS_DRA_PATCH_NAME}")

ExternalProject_Add(ffmpeg
    DEPENDS
        amf-headers
        avisynth-headers
        ${nvcodec_headers}
        bzip2
        lame
        lcms2
        openssl
        libssh
        libsrt
        libass
        libbluray
        libdvdnav
        libdvdread
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
        svtav1
        dav1d
        vapoursynth
        ${ffmpeg_uavs3d}
        ${ffmpeg_davs2}
        rubberband
        libva
        openal-soft
    GIT_REPOSITORY https://github.com/FFmpeg/FFmpeg.git
    GIT_TAG ${FFMPEG_GIT_TAG}
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !tests/ref/fate"
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} bash ${PROJECT_SOURCE_DIR}/scripts/apply_ffmpeg_patches.sh <SOURCE_DIR> ${FFMPEG_PATCH_ROOT} ${CAVS_DRA_GIT_URL} ${CAVS_DRA_GIT_REF} ${CAVS_DRA_PATCH_PATH}
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/configure
        --cross-prefix=${TARGET_ARCH}-
        --prefix=${MINGW_INSTALL_PREFIX}
        --arch=${TARGET_CPU}
        --target-os=mingw32
        --pkg-config-flags=--static
        --enable-cross-compile
        --enable-runtime-cpudetect
        --enable-gpl
        --enable-version3
        --enable-avisynth
        --enable-vapoursynth
        --enable-libass
        --enable-libbluray
        --enable-libdvdnav
        --enable-libdvdread
        --enable-libfreetype
        --enable-libfribidi
        --enable-libfontconfig
        --enable-libharfbuzz
        --enable-libmodplug
        --enable-libopenmpt
        --enable-libmp3lame
        --enable-lcms2
        --enable-libopus
        --enable-libsoxr
        --enable-libspeex
        --enable-libvorbis
        --enable-libbs2b
        --enable-librubberband
        --enable-libvpx
        --enable-libwebp
        --enable-libx264
        --enable-libx265
        --enable-libaom
        --enable-libsvtav1
        --enable-libdav1d
        ${ffmpeg_davs2_cmd}
        ${ffmpeg_uavs3d_cmd}
        --enable-libxvid
        --enable-libzimg
        --enable-openssl
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
        ${ffmpeg_cuda}
        --enable-amf
        --enable-openal
        --enable-opengl
        --disable-doc
        --disable-ffplay
        --disable-ffprobe
        --enable-vaapi
        --disable-vdpau
        --disable-videotoolbox
        --disable-decoder=libaom_av1
        ${ffmpeg_lto}
        --extra-cflags='-Wno-error=int-conversion'
        "--extra-libs='${ffmpeg_extra_libs}'" # -lstdc++ / -lc++ needs by libjxl and shaderc
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(ffmpeg)
cleanup(ffmpeg install)
