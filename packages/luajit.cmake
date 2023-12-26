configure_file(${CMAKE_CURRENT_SOURCE_DIR}/luajit.pc.in ${CMAKE_CURRENT_BINARY_DIR}/luajit.pc @ONLY)
ExternalProject_Add(luajit
    DEPENDS
        libiconv
    GIT_REPOSITORY https://github.com/WohlSoft/LuaJIT.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_REMOTE_NAME origin
    GIT_TAG v2.1
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am --3way ${CMAKE_CURRENT_SOURCE_DIR}/luajit-*.patch
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
        -DCMAKE_CROSSCOMPILING=ON
        -DCMAKE_UNITY_BUILD=ON
        -DLUAJIT_BUILD_TOOL=OFF
        -DLJ_ENABLE_LARGEFILE=ON
        -DLUAJIT_FORCE_UTF8_FOPEN=ON
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
            COMMAND bash -c "cp ${CMAKE_CURRENT_BINARY_DIR}/luajit.pc ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/luajit.pc"
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(luajit)
cleanup(luajit install)
