ExternalProject_Add(amd-fftw
    GIT_REPOSITORY https://github.com/amd/amd-fftw.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/configure
        "CFLAGS='-mavx512f'"
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --enable-static
        --disable-shared
        --enable-sse2
        --enable-avx
        --enable-avx-128-fma
        --enable-avx2
        --enable-avx512
        --enable-amd-opt
        --enable-amd-trans
        --enable-amd-app-opt
        --enable-amd-fast-planner
        --enable-amd-top-n-planner
        --enable-dynamic-dispatcher
        --enable-threads
        --with-our-malloc
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(amd-fftw)
cleanup(amd-fftw install)
