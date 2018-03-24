ExternalProject_Add(readline
    DEPENDS
        termcap
    URL https://ftp.gnu.org/gnu/readline/readline-6.3.tar.gz
    URL_HASH SHA256=56ba6071b9462f980c5a72ab0023893b65ba6debb4eeb475d7a563dc65cafd43
    PATCH_COMMAND patch -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/readline-0001-mingw.patch
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
