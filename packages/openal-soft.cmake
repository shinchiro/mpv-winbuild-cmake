ExternalProject_Add(openal-soft
    DEPENDS
        libsdl2
    GIT_REPOSITORY https://github.com/kcat/openal-soft.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
        -DLIBTYPE=STATIC
        -DALSOFT_UTILS=OFF
        -DALSOFT_EXAMPLES=OFF
        -DALSOFT_TESTS=OFF
        -DALSOFT_BACKEND_PIPEWIRE=OFF
        -DCMAKE_CXX_FLAGS='${CMAKE_CXX_FLAGS} -msse -msse2'
        -DCMAKE_C_FLAGS='${CMAKE_C_FLAGS}     -msse -msse2'
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(openal-soft)
cleanup(openal-soft install)
