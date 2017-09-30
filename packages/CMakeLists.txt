function(force_rebuild _name)
    set(stamp_dir ${CMAKE_CURRENT_BINARY_DIR}/${_name}-prefix/src/${_name}-stamp)
    if(ENABLE_VCS_UPDATES)
        ExternalProject_Add_Step(${_name} force-rebuild
            DEPENDEES build
            COMMAND ${EXEC} rm -f
                "${stamp_dir}/*-autoreconf"
                "${stamp_dir}/*-autogen"
                "${stamp_dir}/*-build"
                "${stamp_dir}/*-configure"
                "${stamp_dir}/*-done"
                "${stamp_dir}/*-download"
                "${stamp_dir}/*-install"
                "${stamp_dir}/*-mkdir"
                "${stamp_dir}/*-patch"
                "${stamp_dir}/*-update"
                "${stamp_dir}/*-done"
                #"${stamp_dir}/*.log"
            ALWAYS 1
        )
    endif()
endfunction()

function(force_rebuild_git _name)
    get_property(git_tag TARGET ${_name} PROPERTY _EP_GIT_TAG)
    if(NOT git_tag)
      set(git_tag "@{u}")
      set(pull COMMAND git pull)
    else()
      set(git_tag ${git_tag})
      set(pull "")
    endif()

    if(ENABLE_VCS_UPDATES)
        ExternalProject_Add_Step(${_name} force-update
            DEPENDEES download
            DEPENDERS update patch
            COMMAND git reset --hard ${git_tag}
            ${pull}
            WORKING_DIRECTORY <SOURCE_DIR>
            ALWAYS 1
            LOG 1
        )
    endif()
    force_rebuild(${_name})
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

function(force_rebuild_hg _name)
    if(ENABLE_VCS_UPDATES)
        ExternalProject_Add_Step(${_name} force-update
            DEPENDEES download
            DEPENDERS update patch
            COMMAND hg --config "extensions.purge=" purge --all
            COMMAND hg update -C
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

function(clean_build_dir _name)
    ExternalProject_Add_Step(${_name} clean_build_dir
        DEPENDEES download update patch configure build install
        COMMAND ${EXEC} rm -rf "<BINARY_DIR>/*"
        ALWAYS 1
    )
endfunction()

foreach(package
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
    libarchive
    freetype2
    libbluray
    harfbuzz
    libsoxr
    libzimg
    libass
    ffmpeg
    angle
    mujs
    vulkan-headers
    shaderc
    mpv
    flac
    opus-tools
    vapoursynth
)
    include(${CMAKE_CURRENT_SOURCE_DIR}/${package}.cmake)
    message(STATUS "Parsing package ${package}")
endforeach()
