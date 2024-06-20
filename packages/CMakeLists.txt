set_property(DIRECTORY PROPERTY EP_STEP_TARGETS download)
include(${PROJECT_SOURCE_DIR}/cmake/packages_check.cmake)
list(APPEND ep
    gmp
    xz
    lzo
    uchardet
    libsamplerate
    rubberband
    zlib
    zstd
    bzip2
    libjpeg
    lcms2
    lame
    ogg
    vorbis
    opus-dnn
    opus
    speex
    libmodplug
    libvpx
    xvidcore
    game-music-emu
    libpng
    x264
    x265
    libdvdcss
    libdvdread
    libdvdnav
    libiconv
    luajit
    fribidi
    expat
    nettle
    mbedtls
    libxml2
    brotli
    freetype2
    libudfread
    libbluray
    harfbuzz
    libsoxr
    graphengine
    libzimg
    fontconfig
    libunibreak
    libass
    libvpl
    amf-headers
    avisynth-headers
    nvcodec-headers
    libmysofa
    aom
    xxhash
    dav1d
    libwebp
    vapoursynth
    libbs2b
    openssl
    libssh
    libsrt
    libarchive
    highway
    libjxl
    uavs3d
    davs2
    angle-headers
    mujs
    spirv-headers
    spirv-tools
    spirv-cross
    glslang
    vulkan-header
    vulkan
    libsdl2
    openal-soft
    libopenmpt
    shaderc
    glad
    fast_float
    libdovi
    svtav1
    libplacebo
    libva
    libzvbi
    libaribcaption
    libsixel
    ffmpeg
    mpv
    mpv-release
    mpv-packaging
    curl
    flac
    opusfile
    libopusenc
    opus-tools
    termcap
    readline
    cryptopp
    sqlite
    libuv
    libsodium
    megasdk
)
foreach(package IN LISTS ep)
    if(NOT ${SINGLE_SOURCE_LOCATION} STREQUAL "")
        set(SOURCE_LOCATION "${SINGLE_SOURCE_LOCATION}/${package}")
    endif()
    include(${CMAKE_CURRENT_SOURCE_DIR}/${package}.cmake)
    set(SOURCE_LOCATION "")

    get_property(_git_repository TARGET ${package} PROPERTY _EP_GIT_REPOSITORY)
    if(_git_repository)
        list(APPEND repo ${package})
    endif()
endforeach()
list(LENGTH ep ep_length)
message(STATUS "Parsing ${ep_length} packages")

# Exclude packages which dont depend on mpv when update
list(APPEND removed "flac" "opusfile" "libopusenc" "opus-tools" "termcap" "readline" "cryptopp" "sqlite" "libuv" "libsodium" "megasdk" "libsixel" "curl" "libressl" "mbedtls" "nettle" "gmp")
list(REMOVE_ITEM repo ${removed})
list(REMOVE_ITEM ep ${removed})
list(TRANSFORM repo APPEND "-force-update" OUTPUT_VARIABLE update)
list(TRANSFORM ep APPEND "-download" OUTPUT_VARIABLE download)
list(TRANSFORM ep APPEND "-fullclean" OUTPUT_VARIABLE fullclean)

add_custom_target(update
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target ${update}
    COMMENT "Updating git repo"
)

add_custom_target(download
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target ${download}
)

add_custom_target(package-fullclean
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target ${fullclean}
    COMMENT "Remove all stamp files, reset git HEAD"
)

add_custom_target(cargo-clean
    COMMAND ${EXEC} LD_PRELOAD= cargo install --git https://github.com/matthiaskrgr/cargo-cache.git --no-default-features --features ci-autoclean cargo-cache
    COMMAND ${EXEC} cargo-cache
    COMMAND du -sh ${RUSTUP_LOCATION}
    USES_TERMINAL
)
