if(CYGWIN OR MSYS)
    set(build --build=${TARGET_ARCH})
endif()

# libarchive required 3rd party iconv.pc when linking
set(VERSION "1.18")
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/libiconv.pc.in ${CMAKE_CURRENT_BINARY_DIR}/libiconv.pc @ONLY)

ExternalProject_Add(libiconv
    URL https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.18.tar.gz
    URL_HASH SHA256=3B08F5F4F9B4EB82F151A7040BFD6FE6C6FB922EFE4B1659C66EA933276965E8
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/configure
        ${build}
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-nls
        --disable-shared
        --enable-extra-encodings
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(libiconv install-pc
    DEPENDEES install
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/libiconv.pc ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/iconv.pc
)

cleanup(libiconv install-pc)
