ExternalProject_Add(gcc
    DEPENDS
        gcc-base
        winpthreads
        gendef
    SOURCE_DIR gcc-prefix/src
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install-strip
    LOG_BUILD 1 LOG_INSTALL 1
)
