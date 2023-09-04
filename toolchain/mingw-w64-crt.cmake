ExternalProject_Add(mingw-w64-crt
    DEPENDS
        mingw-w64
        mingw-w64-headers
        ${gcc_install}
        ${llvm_wrapper}
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    SOURCE_DIR ${MINGW_SRC}
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/mingw-w64-crt/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --with-sysroot=${CMAKE_INSTALL_PREFIX}
        --with-default-msvcrt=ucrt
        ${crt_lib}
        ${cfguard}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install-strip
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(mingw-w64-crt autoreconf
    DEPENDEES download update patch
    DEPENDERS configure
    COMMAND ${EXEC} autoreconf -fi
    WORKING_DIRECTORY <SOURCE_DIR>/mingw-w64-crt
    LOG 1
)

cleanup(mingw-w64-crt install)
