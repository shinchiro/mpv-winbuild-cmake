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

list(APPEND ep
    binutils
    mingw-w64
    mingw-w64-headers
    gcc-base
    mingw-w64-crt
    winpthreads
    gendef
    gcc
    widl
)

foreach(package IN LISTS ep)
    include(${CMAKE_CURRENT_SOURCE_DIR}/${package}.cmake)
    message(STATUS "Parsing package ${package}")
endforeach()
