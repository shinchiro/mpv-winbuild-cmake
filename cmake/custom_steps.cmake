function(cleanup _name _last_step)
    get_property(_build_in_source TARGET ${_name} PROPERTY _EP_BUILD_IN_SOURCE)
    get_property(_git_repository TARGET ${_name} PROPERTY _EP_GIT_REPOSITORY)
    get_property(_url TARGET ${_name} PROPERTY _EP_URL)
    get_property(git_tag TARGET ${_name} PROPERTY _EP_GIT_TAG)
    get_property(git_remote_name TARGET ${_name} PROPERTY _EP_GIT_REMOTE_NAME)
    get_property(source_dir TARGET ${_name} PROPERTY _EP_SOURCE_DIR)

    if("${git_remote_name}" STREQUAL "" AND NOT "${git_tag}" STREQUAL "")
        # GIT_REMOTE_NAME is not set when commit hash is specified
        set(git_tag "")
    else()
        set(git_tag "@{u}")
    endif()

    if(_git_repository)
        if(_build_in_source)
            set(remove_cmd "git -C <SOURCE_DIR> clean -dfx")
        else()
            set(remove_cmd "rm -rf <BINARY_DIR>/* && git -C <SOURCE_DIR> clean -df")
        endif()
        set(COMMAND_FORCE_UPDATE COMMAND bash -c "git -C <SOURCE_DIR> am --abort 2> /dev/null || true"
                                 COMMAND bash -c "git -C <SOURCE_DIR> restore .")
    elseif(_url)
        set(remove_cmd "rm -rf <SOURCE_DIR>/* <BINARY_DIR>/*")
        set(COMMAND_FORCE_UPDATE "")
    endif()

    # <STAMP_DIR> doesn't resolve into full path, so <LOG_DIR> is used instead since its same folder.
    ExternalProject_Add_Step(${_name} fullclean
        COMMAND ${EXEC} find <LOG_DIR> -type f " ! -iname '*.cmake' " -size 0c -delete # remove 0 byte files which are stamp files
        ${COMMAND_FORCE_UPDATE}
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        LOG 1
        COMMENT "Deleting all stamp files of ${_name} package"
    )

    ExternalProject_Add_Step(${_name} liteclean
        COMMAND ${EXEC} rm -f <LOG_DIR>/${_name}-build
                              <LOG_DIR>/${_name}-install
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        LOG 1
        COMMENT "Deleting build, install stamp files of ${_name} package"
    )

    if(ALWAYS_REMOVE_BUILDFILES)
        ExternalProject_Add_Step(${_name} postremovebuild
            DEPENDEES ${_last_step}
            COMMAND ${EXEC} ${remove_cmd}
            LOG 1
            COMMENT "Deleting build directory of ${_name} package after install"
        )
    endif()

    ExternalProject_Add_Step(${_name} removebuild
        DEPENDEES fullclean
        COMMAND ${EXEC} ${remove_cmd}
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        LOG 1
        COMMENT "Deleting build directory of ${_name} package"
    )

    ExternalProject_Add_Step(${_name} removeprefix
        COMMAND ${EXEC} rm -rf <INSTALL_DIR> ${source_dir}
        COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target rebuild_cache
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        LOG 1
        COMMENT "Deleting everything about ${_name} package"
    )
    ExternalProject_Add_StepTargets(${_name} fullclean liteclean removeprefix removebuild)
endfunction()

function(force_rebuild_git _name)
    get_property(git_tag TARGET ${_name} PROPERTY _EP_GIT_TAG)
    get_property(git_reset TARGET ${_name} PROPERTY _EP_GIT_RESET)
    get_property(git_remote_name TARGET ${_name} PROPERTY _EP_GIT_REMOTE_NAME)
    get_property(stamp_dir TARGET ${_name} PROPERTY _EP_STAMP_DIR)
    get_property(source_dir TARGET ${_name} PROPERTY _EP_SOURCE_DIR)

    if("${git_remote_name}" STREQUAL "" AND NOT "${git_tag}" STREQUAL "")
        # GIT_REMOTE_NAME is not set when commit hash is specified
        set(reset "")
    elseif(NOT "${git_reset}" STREQUAL "")
        set(reset "${git_reset}")
    else()
        set(reset "@{u}") # eg: origin/master
    endif()

file(WRITE ${stamp_dir}/reset_head.sh
"#!/bin/bash
git fetch --filter=tree:0
if [[ ! -f \"${stamp_dir}/${_name}-patch\"  || \"${stamp_dir}/${_name}-download\" -nt \"${stamp_dir}/${_name}-patch\" || ! -f \"${stamp_dir}/HEAD\" || \"$(cat ${stamp_dir}/HEAD)\" != \"$(git rev-parse @{u})\" ]]; then
    git reset --hard ${reset} -q
    if [[ -z \"${git_reset}\" ]]; then
        find \"${stamp_dir}\" -type f  ! -iname '*.cmake' -size 0c -delete
        echo \"Removing ${_name} stamp files.\"
        git rev-parse HEAD > ${stamp_dir}/HEAD
    fi
else
    git reset --hard -q
fi")

    ExternalProject_Add_Step(${_name} force-update
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        WORKING_DIRECTORY <SOURCE_DIR>
        COMMAND bash -c "git am --abort 2> /dev/null || true"
        COMMAND chmod 755 ${stamp_dir}/reset_head.sh && ${stamp_dir}/reset_head.sh
    )
    ExternalProject_Add_StepTargets(${_name} force-update)

    ExternalProject_Add_Step(${_name} write-head
        DEPENDERS patch
        INDEPENDENT TRUE
        WORKING_DIRECTORY <SOURCE_DIR>
        COMMAND bash -c "git rev-parse HEAD > ${stamp_dir}/HEAD"
        LOG 1
    )

    if(EXISTS ${source_dir}/.git)
        ExternalProject_Add_Step(${_name} check-git
            DEPENDERS download
            INDEPENDENT TRUE
            WORKING_DIRECTORY ${stamp_dir}
            COMMAND ${CMAKE_COMMAND} -E touch <INSTALL_DIR>/src/${_name}-stamp/${_name}-download
            COMMAND ${CMAKE_COMMAND} -E copy ${_name}-gitinfo.txt ${_name}-gitclone-lastrun.txt
            LOG 1
        )
    else()
        execute_process(
            WORKING_DIRECTORY ${stamp_dir}
            COMMAND ${EXEC} rm ${_name}-gitclone-lastrun.txt
            ERROR_QUIET
        )
    endif()
endfunction()

function(force_rebuild_svn _name)
    ExternalProject_Add_Step(${_name} force-update
        DEPENDEES download update
        DEPENDERS patch build install
        COMMAND svn revert -R .
        COMMAND svn up
        WORKING_DIRECTORY <SOURCE_DIR>
        LOG 1
    )
endfunction()

function(force_rebuild_hg _name)
    ExternalProject_Add_Step(${_name} force-update
        DEPENDEES download update
        DEPENDERS patch build install
        COMMAND hg --config "extensions.purge=" purge --all
        COMMAND hg update -C
        WORKING_DIRECTORY <SOURCE_DIR>
        LOG 1
    )
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
