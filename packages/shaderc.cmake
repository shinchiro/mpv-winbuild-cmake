ExternalProject_Add(shaderc
    GIT_REPOSITORY https://github.com/google/shaderc.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/shaderc-*.patch
    COMMAND mkdir -p <SOURCE_DIR>/build
    CONFIGURE_COMMAND ${EXEC} cd <SOURCE_DIR>/build && cmake -B. -H..
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=<SOURCE_DIR>/cmake/linux-mingw-toolchain.cmake
        -DSHADERC_SKIP_TESTS=ON
        -DCMAKE_CXX_FLAGS='${CMAKE_CXX_FLAGS} -fno-rtti'
        -DMINGW_COMPILER_PREFIX=${TARGET_ARCH}
    BUILD_COMMAND ${MAKE} -i -C <SOURCE_DIR>/build
    INSTALL_COMMAND ""
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(shaderc pull
    DEPENDEES download patch
    DEPENDERS configure
    WORKING_DIRECTORY <SOURCE_DIR>/third_party
    COMMAND ${EXEC} ./pull.sh
    COMMENT "Pull dependencies"
)

ExternalProject_Add_Step(shaderc manual-install
    DEPENDEES build
    COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/libshaderc/include/shaderc ${MINGW_INSTALL_PREFIX}/include/shaderc
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/libshaderc/libshaderc_combined.a ${MINGW_INSTALL_PREFIX}/lib/libshaderc_shared.a
    COMMENT "Manually installing"
)

force_rebuild_git(shaderc)
extra_step(shaderc)
