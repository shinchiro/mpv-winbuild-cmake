set_property(DIRECTORY PROPERTY EP_STEP_TARGETS download)
include(${PROJECT_SOURCE_DIR}/cmake/packages_check.cmake)
list(APPEND ep
    gmp
    xz
    lzo
    uchardet
    rubberband
    zlib
    bzip2
    libjpeg
    lcms2
    lame
    ogg
    vorbis
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
    openal-soft
    fribidi
    expat
    nettle
    libarchive
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
    mbedtls
    libxml2
    libvpl
    amf-headers
    avisynth-headers
    nvcodec-headers
    libmysofa
    aom
    dav1d
    libwebp
    vapoursynth
    libbs2b
    libssh
    libsdl2
    libsrt
    libopenmpt
    brotli
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
    shaderc
    glad
    fast_float
    libdovi
    rav1e
    xxhash
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
list(APPEND removed "flac" "opusfile" "libopusenc" "opus-tools" "termcap" "readline" "cryptopp" "sqlite" "libuv" "libsodium" "megasdk" "libsixel" "curl")
list(REMOVE_ITEM repo ${removed})
list(REMOVE_ITEM ep ${removed})
list(TRANSFORM repo APPEND "-force-update" OUTPUT_VARIABLE update)
list(TRANSFORM ep APPEND "-download" OUTPUT_VARIABLE download)

add_custom_target(update
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target ${update}
    COMMENT "Updating git repo"
)

add_custom_target(download
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target ${download}
)

add_custom_target(cargo-clean
    COMMAND ${EXEC} cargo install --git https://github.com/matthiaskrgr/cargo-cache.git --no-default-features --features ci-autoclean cargo-cache
    COMMAND ${EXEC} cargo-cache
    COMMAND du -sh ${RUSTUP_LOCATION}
    USES_TERMINAL
)
