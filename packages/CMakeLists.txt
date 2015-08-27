function(force_rebuild _name)
    ExternalProject_Add_Step(${_name} force-rebuild
        DEPENDEES build
        COMMAND ${EXEC} rm -f
            "<SOURCE_DIR>-stamp/*-autoreconf"
            "<SOURCE_DIR>-stamp/*-autogen"
            "<SOURCE_DIR>-stamp/*-configure"
            "<SOURCE_DIR>-stamp/*-build"
            "<SOURCE_DIR>-stamp/*-patch"
        ALWAYS 1
    )
endfunction()

function(force_rebuild_git _name)
    if(ENABLE_VCS_UPDATES)
        ExternalProject_Add_Step(${_name} force-update
            DEPENDEES download
            DEPENDERS update patch
            COMMAND git reset --hard @{u}
                COMMAND git pull
            WORKING_DIRECTORY <SOURCE_DIR>
            ALWAYS 1
            LOG 1
        )

        force_rebuild(${_name})
    endif()
endfunction()

function(force_rebuild_svn _name)
    if(ENABLE_VCS_UPDATES)
        ExternalProject_Add_Step(${_name} force-update
            DEPENDEES download
            DEPENDERS update patch
            COMMAND svn revert -R .
            COMMAND svn up
            WORKING_DIRECTORY <SOURCE_DIR>
            ALWAYS 1
            LOG 1
        )

        force_rebuild(${_name})
    endif()
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
    xz
    lzo
    libressl
    uchardet
    rubberband
    libwaio
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
    libmodplug
    libvpx
    xvidcore
    opencore-amr
    fdk-aac
    game-music-emu
    librtmp
    libpng
    x264
    libdvdcss
    libdvdread
    libdvdnav
    libiconv
    luajit
    openal-soft
    fribidi
    expat
    libarchive
    freetype2
    libbluray
    fontconfig
    harfbuzz
    libass
    dcadec
    ffmpeg
    mpv
)
    include(${CMAKE_CURRENT_SOURCE_DIR}/${package}.cmake)
    message(STATUS "Parsing package ${package}")
endforeach()
