function(force_rebuild _name)
    ExternalProject_Add_Step(${_name} force-rebuild
        DEPENDEES build
        COMMAND ${EXEC} rm -f
            "<SOURCE_DIR>-stamp/*-autoreconf"
            "<SOURCE_DIR>-stamp/*-autogen"
            "<SOURCE_DIR>-stamp/*-configure"
            "<SOURCE_DIR>-stamp/*-build"
        ALWAYS 1
    )
endfunction()

function(force_rebuild_git _name)
    ExternalProject_Add_Step(${_name} force-update
        DEPENDEES download patch
        DEPENDERS update
        COMMAND git reset --hard
        COMMAND git pull --rebase
        WORKING_DIRECTORY <SOURCE_DIR>
        ALWAYS 1
        LOG 1
    )

    force_rebuild(${_name})
endfunction()

function(force_rebuild_svn _name)
    ExternalProject_Add_Step(${_name} force-update
        DEPENDEES download patch
        DEPENDERS update
        COMMAND svn up
        WORKING_DIRECTORY <SOURCE_DIR>
        ALWAYS 1
        LOG 1
    )

    force_rebuild(${_name})
endfunction()

function(autogen _name)
    ExternalProject_Add_Step(${_name} autogen
        DEPENDEES download update patch
        DEPENDERS configure
        COMMAND ${EXEC} ./autogen.sh -V
        WORKING_DIRECTORY <SOURCE_DIR>
        LOG 1
    )
endfunction()

function(autoreconf _name)
    ExternalProject_Add_Step(${_name} autoreconf
        DEPENDEES download update patch
        DEPENDERS configure
        COMMAND ${EXEC} autoreconf -fi
        WORKING_DIRECTORY <SOURCE_DIR>
        LOG 1
    )
endfunction()

foreach(package
    winpthreads
#    pthreads-w32
    zlib
    bzip2
    libjpeg
    lcms2
    lame
    ogg
    vorbis
    theora
    opus
    speex
    wavpack
    libmodplug
    libvpx
    xvidcore
    opencore-amr
    fdk-aac
    game-music-emu
    libgpg_error
    libgcrypt
    libpng
    libxml2
    x264
    libdvdcss
    libdvdread
    libdvdnav
    libcurl
    libiconv
    gettext
    lua
    luajit
    luasocket
    luaexpat
    openal-soft
    portaudio
    fribidi
    expat
    freetype2
    libbluray
    fontconfig
    enca
    libffi
    pcre
    gmp
    nettle
    gnutls
    glib
    libquvi_scripts
    libquvi
    harfbuzz
    libass
    ffmpeg
    mpv
)
    include(${package}.cmake)
    message(STATUS "Parsing package ${package}")
endforeach()
