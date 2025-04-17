function(cleanup _name _last_step)
    get_property(_build_in_source TARGET ${_name} PROPERTY _EP_BUILD_IN_SOURCE)
    get_property(_git_repository TARGET ${_name} PROPERTY _EP_GIT_REPOSITORY)
    get_property(_url TARGET ${_name} PROPERTY _EP_URL)
    get_property(git_tag TARGET ${_name} PROPERTY _EP_GIT_TAG)
    get_property(git_remote_name TARGET ${_name} PROPERTY _EP_GIT_REMOTE_NAME)
    get_property(stamp_dir TARGET ${_name} PROPERTY _EP_STAMP_DIR)
    get_property(source_dir TARGET ${_name} PROPERTY _EP_SOURCE_DIR)

    if("${git_remote_name}" STREQUAL "" AND NOT "${git_tag}" STREQUAL "")
        # GIT_REMOTE_NAME is not set when commit hash is specified
        set(git_tag "")
    else()
        set(git_tag "@{u}")
    endif()

    if(_git_repository)
        if(EXISTS ${source_dir}/.git)
            if(_build_in_source)
                set(remove_cmd ${EXEC} git -C <SOURCE_DIR> clean -ffxd)
            else()
                set(remove_cmd ${EXEC} find <BINARY_DIR> -mindepth 1 -delete & ${EXEC} git -C <SOURCE_DIR> clean -ffxd)
            endif()
            set(COMMAND_FORCE_UPDATE COMMAND bash -c "git -C <SOURCE_DIR> am --abort 2> /dev/null || true"
                                     COMMAND ${stamp_dir}/reset_head.sh
                                     COMMAND bash -c "git -C <SOURCE_DIR> restore .")
        else()
            if(_build_in_source)
                set(remove_cmd ${EXEC} true)
            else()
                set(remove_cmd ${EXEC} find <BINARY_DIR> -mindepth 1 -delete)
            endif()
        endif()
    else()
        set(remove_cmd ${EXEC} find <BINARY_DIR> -mindepth 1 -delete)
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

    ExternalProject_Add_Step(${_name} postremovebuild
        DEPENDEES ${_last_step}
        COMMAND ${remove_cmd}
        ${COMMAND_FORCE_UPDATE}
        LOG 1
        COMMENT "Deleting build directory of ${_name} package after install"
    )

    ExternalProject_Add_Step(${_name} removebuild
        DEPENDEES fullclean
        COMMAND ${remove_cmd}
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        LOG 1
        COMMENT "Deleting build directory of ${_name} package"
    )

    ExternalProject_Add_Step(${_name} removeprefix
        COMMAND ${EXEC} find <INSTALL_DIR> ${source_dir} -mindepth 1 -delete
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
    get_property(git_clone_flags TARGET ${_name} PROPERTY _EP_GIT_CLONE_FLAGS)

    if("${git_remote_name}" STREQUAL "" AND NOT "${git_tag}" STREQUAL "")
        # GIT_REMOTE_NAME is not set when commit hash is specified
        set(reset "")
    elseif(NOT "${git_reset}" STREQUAL "")
        set(reset "${git_reset}")
    else()
        set(reset "@{u}") # eg: origin/master
    endif()
    if("${git_remote_name}" STREQUAL "")
        set(git_remote_name "origin")
    endif()
    if("${git_tag}" STREQUAL "")
        set(git_tag "master")
    endif()
    if(${git_clone_flags} MATCHES "--depth=1")
        set(shallow_fetch "--depth 1")
    endif()

file(WRITE ${stamp_dir}/reset_head.sh
"#!/bin/bash
set -e
if [[ ! -f \"${stamp_dir}/${_name}-patch\"  || \"${stamp_dir}/${_name}-download\" -nt \"${stamp_dir}/${_name}-patch\" || ! -f \"${stamp_dir}/HEAD\" || \"$(cat ${stamp_dir}/HEAD)\" != \"$(git -C ${source_dir} rev-parse @{u})\" ]]; then
    git -C ${source_dir} reset --hard ${reset} -q
    if [[ -z \"${git_reset}\" ]]; then
        find \"${stamp_dir}\" -type f  ! -iname '*.cmake' -size 0c -delete
        echo \"Removing ${_name} stamp files.\"
        git -C ${source_dir} rev-parse HEAD > ${stamp_dir}/HEAD
    fi
else
    git -C ${source_dir} reset --hard -q
fi")
file(CHMOD ${stamp_dir}/reset_head.sh 
PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

    ExternalProject_Add_Step(${_name} force-update
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        WORKING_DIRECTORY <SOURCE_DIR>
        COMMAND bash -c "git am --abort 2> /dev/null || true"
        COMMAND bash -c "git fetch ${shallow_fetch} --prune --prune-tags --atomic --filter=tree:0 --no-recurse-submodules ${git_remote_name} ${git_tag}"
        COMMAND ${stamp_dir}/reset_head.sh
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
            COMMAND ${CMAKE_COMMAND} -E rm ${_name}-gitclone-lastrun.txt
            ERROR_QUIET
        )
    endif()
endfunction()
