if(CYGWIN OR MSYS)
    set(target --build=${TARGET_ARCH})
else()
    set(target --host=${TARGET_ARCH})
endif()

ExternalProject_Add(libiconv
    URL "http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz"
    URL_MD5 e34509b1623cec449dfeb73d7ce9c6c6
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        ${target}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-nls
        --disable-shared
        --enable-extra-encodings
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

clean_build_dir(libiconv)
force_rebuild(libiconv)
