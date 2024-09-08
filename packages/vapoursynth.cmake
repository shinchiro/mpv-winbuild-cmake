if(${TARGET_CPU} MATCHES "x86_64" OR ${TARGET_CPU} MATCHES "aarch64")
    set(rev "R65")
else()
    set(rev "R63")
    set(dlltool_opts "-U")
endif()

string(REPLACE "R" "" PC_VERSION ${rev})
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/vapoursynth.pc.in ${CMAKE_CURRENT_BINARY_DIR}/vapoursynth.pc @ONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/vapoursynth-script.pc.in ${CMAKE_CURRENT_BINARY_DIR}/vapoursynth-script.pc @ONLY)
set(GENERATE_DEF ${CMAKE_CURRENT_BINARY_DIR}/vapoursynth-prefix/src/generate_def.sh)
file(WRITE ${GENERATE_DEF}
"#!/bin/bash
if [[ \"$1\" != \"i686\" ]]; then
    sed -r -e 's|@[0-9]+$||' -i $2
fi")

ExternalProject_Add(vapoursynth
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1
)

ExternalProject_Add_Step(vapoursynth generate-def
    DEPENDEES install
    WORKING_DIRECTORY <SOURCE_DIR>
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/VapourSynth.def <SOURCE_DIR>/VapourSynth.def
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/VSScript.def    <SOURCE_DIR>/VSScript.def
    COMMAND chmod 755 ${GENERATE_DEF}
    COMMAND ${EXEC} ${GENERATE_DEF} ${TARGET_CPU} VapourSynth.def
    COMMAND ${EXEC} ${GENERATE_DEF} ${TARGET_CPU} VSScript.def
    LOG 1
)

if(COMPILER_TOOLCHAIN STREQUAL "gcc")
ExternalProject_Add_Step(vapoursynth generate-lib
    DEPENDEES generate-def
    WORKING_DIRECTORY <SOURCE_DIR>
    COMMAND ${EXEC} ${TARGET_ARCH}-dlltool -d VSScript.def -y libvsscript.a ${dlltool_opts}
    COMMAND ${EXEC} ${TARGET_ARCH}-dlltool -d VapourSynth.def -y libvapoursynth.a ${dlltool_opts}
    LOG 1
)
elseif(COMPILER_TOOLCHAIN STREQUAL "clang")
ExternalProject_Add_Step(vapoursynth generate-lib
    DEPENDEES generate-def
    WORKING_DIRECTORY <SOURCE_DIR>
    COMMAND ${EXEC} ${TARGET_ARCH}-dlltool -m ${dlltool_image} -d VSScript.def -l VSScript.lib
    COMMAND ${EXEC} ${TARGET_ARCH}-dlltool -m ${dlltool_image} -d VapourSynth.def -l VapourSynth.lib
    LOG 1
)
endif()

ExternalProject_Add_Step(vapoursynth download-header
    DEPENDEES generate-lib
    WORKING_DIRECTORY <SOURCE_DIR>
    COMMAND curl -sOL https://raw.githubusercontent.com/vapoursynth/vapoursynth/${rev}/include/VapourSynth.h
    COMMAND curl -sOL https://raw.githubusercontent.com/vapoursynth/vapoursynth/${rev}/include/VapourSynth4.h
    COMMAND curl -sOL https://raw.githubusercontent.com/vapoursynth/vapoursynth/${rev}/include/VSScript.h
    COMMAND curl -sOL https://raw.githubusercontent.com/vapoursynth/vapoursynth/${rev}/include/VSScript4.h
    LOG 1
)

ExternalProject_Add_Step(vapoursynth manual-install
    DEPENDEES download-header
    WORKING_DIRECTORY <SOURCE_DIR>
    # Copying header
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/VapourSynth.h ${MINGW_INSTALL_PREFIX}/include/vapoursynth/VapourSynth.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/VapourSynth4.h ${MINGW_INSTALL_PREFIX}/include/vapoursynth/VapourSynth4.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/VSScript.h ${MINGW_INSTALL_PREFIX}/include/vapoursynth/VSScript.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/VSScript4.h ${MINGW_INSTALL_PREFIX}/include/vapoursynth/VSScript4.h
    # Copying libs
    ${vapoursynth_manual_install_copy_lib}
    # Copying .pc files
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/vapoursynth.pc ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/vapoursynth.pc
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/vapoursynth-script.pc ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/vapoursynth-script.pc
)

cleanup(vapoursynth manual-install)
