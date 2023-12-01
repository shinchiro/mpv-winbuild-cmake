ExternalProject_Add(libarchive
    DEPENDS
        bzip2
        expat
        libiconv
        libxml2
        lzo
        openssl
        xz
        zlib
        zstd
    GIT_REPOSITORY https://github.com/libarchive/libarchive.git
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
        -DBUILD_TESTING=OFF
        -DENABLE_BZip2=ON
        -DENABLE_CAT=OFF
        -DENABLE_CNG=OFF
        -DENABLE_CPIO=OFF
        -DENABLE_EXPAT=ON
        -DENABLE_ICONV=ON
        -DENABLE_LIBXML2=ON
        -DENABLE_LZMA=ON
        -DENABLE_LZO=ON
        -DENABLE_OPENSSL=ON
        -DENABLE_TAR=OFF
        -DENABLE_TEST=OFF
        -DENABLE_WERROR=OFF
        -DENABLE_ZLIB=ON
        -DENABLE_ZSTD=ON
        -DWINDOWS_VERSION=WIN10
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libarchive)
cleanup(libarchive install)
