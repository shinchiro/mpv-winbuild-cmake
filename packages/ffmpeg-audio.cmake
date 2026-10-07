# Slim, audio-only FFmpeg used when AUDIO_ONLY=ON (replaces ffmpeg.cmake).
# Everything is disabled first and then white-listed, so the binary only contains
# what a music player needs. Muxers are kept for mpv's stream-record / dump-cache.
# Every component name below was checked against `configure --list-*` of FFmpeg master.
# No GPL libraries are linked, so the result is LGPL (version3 is needed by OpenSSL).

# Audio decoders (native ones only, no external codec libraries), plus decoders
# for the cover art that is embedded in audio files.
set(ffmpeg_audio_decoders
    aac aac_latm ac3 eac3 alac ape flac
    mp1 mp1float mp2 mp2float mp3 mp3float
    mpc7 mpc8 opus vorbis wavpack
    wmav1 wmav2 wmapro wmalossless
    tak tta dca truehd mlp shorten
    atrac1 atrac3 atrac3p cook ra_144 ra_288 ralf
    gsm gsm_ms amrnb amrwb
    dsd_lsbf dsd_msbf dsd_lsbf_planar dsd_msbf_planar
    pcm_s8 pcm_u8 pcm_s16le pcm_s16be pcm_s24le pcm_s24be pcm_s32le pcm_s32be
    pcm_f32le pcm_f32be pcm_f64le pcm_f64be pcm_alaw pcm_mulaw
    adpcm_ima_wav adpcm_ms
    mjpeg png bmp gif webp
)
set(ffmpeg_audio_demuxers
    aac ac3 aiff amr ape asf au avi dsf dts dtshd eac3 flac flv gsm hls
    matroska mov mp3 mpc mpc8 mpegts ogg oma rm shorten tak truehd tta wav wv xwma
)
set(ffmpeg_audio_parsers
    aac aac_latm ac3 cook flac gsm mpegaudio opus tak vorbis dca mjpeg png webp
)
# Requested muxers: mp3 flac ogg ipod(m4a) matroska wav adts. `opus` is added so that
# *.opus files are picked by extension; it is tiny.
set(ffmpeg_audio_muxers
    mp3 flac ogg opus ipod matroska wav adts
)
set(ffmpeg_audio_protocols
    async cache crypto data file http httpproxy https pipe subfile tcp tls
)
# buffer/abuffer/buffersink/abuffersink are always built and need no entry.
set(ffmpeg_audio_filters
    aformat format aresample atempo anull null volume equalizer anequalizer
    loudnorm dynaudnorm acompressor alimiter extrastereo pan channelmap
    channelsplit amix scale overlay
)
# aac_adtstoasc is required to put ADTS AAC into the ipod muxer.
set(ffmpeg_audio_bsfs
    aac_adtstoasc extract_extradata
)

function(ffmpeg_audio_join _out)
    list(JOIN ARGN "," _joined)
    set(${_out} "${_joined}" PARENT_SCOPE)
endfunction()
ffmpeg_audio_join(ffmpeg_audio_decoders_opt  ${ffmpeg_audio_decoders})
ffmpeg_audio_join(ffmpeg_audio_demuxers_opt  ${ffmpeg_audio_demuxers})
ffmpeg_audio_join(ffmpeg_audio_parsers_opt   ${ffmpeg_audio_parsers})
ffmpeg_audio_join(ffmpeg_audio_muxers_opt    ${ffmpeg_audio_muxers})
ffmpeg_audio_join(ffmpeg_audio_protocols_opt ${ffmpeg_audio_protocols})
ffmpeg_audio_join(ffmpeg_audio_filters_opt   ${ffmpeg_audio_filters})
ffmpeg_audio_join(ffmpeg_audio_bsfs_opt      ${ffmpeg_audio_bsfs})

ExternalProject_Add(ffmpeg
    DEPENDS
        zlib
        openssl
    GIT_REPOSITORY https://github.com/FFmpeg/FFmpeg.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !tests/ref/fate"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/configure
        --cross-prefix=${TARGET_ARCH}-
        --prefix=${MINGW_INSTALL_PREFIX}
        --arch=${TARGET_CPU}
        --target-os=mingw32
        --pkg-config-flags=--static
        --enable-cross-compile
        --enable-runtime-cpudetect
        --enable-version3
        --disable-autodetect
        --disable-everything
        --disable-debug
        --disable-doc
        --disable-programs
        --disable-avdevice
        --disable-hwaccels
        --enable-network
        --enable-zlib
        --enable-openssl
        --enable-decoder=${ffmpeg_audio_decoders_opt}
        --enable-demuxer=${ffmpeg_audio_demuxers_opt}
        --enable-parser=${ffmpeg_audio_parsers_opt}
        --enable-muxer=${ffmpeg_audio_muxers_opt}
        --enable-protocol=${ffmpeg_audio_protocols_opt}
        --enable-filter=${ffmpeg_audio_filters_opt}
        --enable-bsf=${ffmpeg_audio_bsfs_opt}
        ${ffmpeg_lto}
        --extra-cflags='-Wno-error=int-conversion'
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(ffmpeg)
cleanup(ffmpeg install)
