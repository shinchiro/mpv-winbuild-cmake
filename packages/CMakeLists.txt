function(extra_step _name)
    get_property(_build_in_source TARGET ${_name} PROPERTY _EP_BUILD_IN_SOURCE)
    get_property(_git_repository TARGET ${_name} PROPERTY _EP_GIT_REPOSITORY)
    get_property(_url TARGET ${_name} PROPERTY _EP_URL)

    if(_build_in_source)
        if(_git_repository)
            set(remove_cmd "git -C <SOURCE_DIR> clean -dfx")
        elseif(_url)
            set(remove_cmd "rm -rf <SOURCE_DIR>")
        endif()
    else()
        set(remove_cmd "rm -rf <BINARY_DIR>")
    endif()

    ExternalProject_Add_Step(${_name} fullclean
        COMMAND ${EXEC} find <DOWNLOAD_DIR>/${_name}-stamp -type f " ! -iname '*.cmake' " -size 0c -delete # remove 0 byte files which are stamp files
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        COMMENT "Deleting all stamp files of ${_name} package"
    )

    ExternalProject_Add_Step(${_name} liteclean
        COMMAND ${EXEC} rm -f <DOWNLOAD_DIR>/${_name}-stamp/${_name}-build
                              <DOWNLOAD_DIR>/${_name}-stamp/${_name}-install
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        COMMENT "Deleting build, install stamp files of ${_name} package"
    )

    ExternalProject_Add_Step(${_name} removebuild
        DEPENDEES fullclean
        COMMAND ${EXEC} ${remove_cmd}
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        LOG 1
        COMMENT "Deleting build directory of ${_name} package"
    )

    ExternalProject_Add_StepTargets(${_name} fullclean liteclean removebuild)
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

function(force_meson_configure _name)
    ExternalProject_Add_Step(${_name} force-meson-configure
        DEPENDERS configure
        COMMAND ${EXEC} rm -rf <BINARY_DIR>/meson-*
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
    nettle
    libarchive
    freetype2
    libbluray
    harfbuzz
    libsoxr
    libzimg
    fontconfig
    libass
    libressl
    libxml2
    libmfx
    amf-headers
    nvcodec-headers
    libmysofa
    aom
    dav1d
    libwebp
    vapoursynth
    libbs2b
    libssh
    ffmpeg
    angle-headers
    mujs
    spirv-headers
    spirv-tools
    spirv-cross
    glslang
    vulkan
    shaderc
    libplacebo
    curl
    libsdl2
    mpv
    mpv-stable
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
    include(${CMAKE_CURRENT_SOURCE_DIR}/${package}.cmake)
    message(STATUS "Parsing package ${package}")
endforeach()

set(UPDATE_SCRIPT ${CMAKE_SOURCE_DIR}/scripts/update-repo.sh)
add_custom_target(update
    USES_TERMINAL
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMAND chmod 755 ${UPDATE_SCRIPT}
    COMMAND ${EXEC} ${UPDATE_SCRIPT}
    COMMENT "Updating git repo"
)
