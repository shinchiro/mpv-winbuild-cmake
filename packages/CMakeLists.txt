function(clean _name)
    set(stamp_dir ${CMAKE_CURRENT_BINARY_DIR}/${_name}-prefix/src/${_name}-stamp)
    ExternalProject_Add_Step(${_name} clean
        WORKING_DIRECTORY <SOURCE_DIR>
        COMMAND ${EXEC} find ${stamp_dir} -type f " ! -iname '*.cmake' " -size 0c -delete # remove 0 byte files which are stamp files
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
    )
    ExternalProject_Add_StepTargets(${_name} clean)
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
            LOG 1
        )
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
            LOG 1
        )
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
            LOG 1
        )
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
        DEPENDEES build install
        COMMAND ${EXEC} rm -rf "<BINARY_DIR>/*"
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
    vulkan
    shaderc
    crossc
    mpv
    flac
    opus-tools
    vapoursynth
)
    include(${CMAKE_CURRENT_SOURCE_DIR}/${package}.cmake)
    message(STATUS "Parsing package ${package}")
endforeach()
