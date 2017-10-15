function(extra_step _name)
    set(stamp_dir ${CMAKE_CURRENT_BINARY_DIR}/${_name}-prefix/src/${_name}-stamp)

    ExternalProject_Add_Step(${_name} fullclean
        WORKING_DIRECTORY <SOURCE_DIR>
        COMMAND ${EXEC} find ${stamp_dir} -type f " ! -iname '*.cmake' " -size 0c -delete # remove 0 byte files which are stamp files
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        COMMENT "Deleting all stamp files of ${_name} package"
    )

    ExternalProject_Add_Step(${_name} liteclean
        WORKING_DIRECTORY <SOURCE_DIR>
        COMMAND ${EXEC} rm -f ${CMAKE_CURRENT_BINARY_DIR}/${_name}-prefix/src/${_name}-stamp/${_name}-build
                              ${CMAKE_CURRENT_BINARY_DIR}/${_name}-prefix/src/${_name}-stamp/${_name}-install
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        COMMENT "Deleting build, clean stamp files of ${_name} package"
    )
    ExternalProject_Add_StepTargets(${_name} fullclean liteclean)
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
            DEPENDEES download update
            DEPENDERS patch build install
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
            DEPENDEES download update
            DEPENDERS patch build install
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
            DEPENDEES download update
            DEPENDERS patch build install
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
foreach(package IN LISTS ep)
    include(${CMAKE_CURRENT_SOURCE_DIR}/${package}.cmake)
    message(STATUS "Parsing package ${package}")
endforeach()
