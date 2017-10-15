if(${TARGET_CPU} MATCHES "x86_64")
    set(libvpx_target "x86_64-win64-gcc")
else()
    set(libvpx_target "x86-win32-gcc")
endif()

ExternalProject_Add(libvpx
    GIT_REPOSITORY https://chromium.googlesource.com/webm/libvpx.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CROSS=${TARGET_ARCH}- <SOURCE_DIR>/configure
        --target=${libvpx_target}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-examples
        --disable-install-docs
        --disable-unit-tests
        --as=yasm
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    COMMAND ${EXEC} ${TARGET_ARCH}-ranlib ${MINGW_INSTALL_PREFIX}/lib/libvpx.a
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libvpx)
extra_step(libvpx)
