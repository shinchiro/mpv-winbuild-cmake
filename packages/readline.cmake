ExternalProject_Add(readline
    DEPENDS
        termcap
    URL https://ftp.gnu.org/gnu/readline/readline-8.0.tar.gz
    URL_HASH SHA256=e339f51971478d369f8a053a330a190781acb9864cf4c541060f12078948e461
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --enable-static
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(readline)
