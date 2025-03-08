ExternalProject_Add(libarchive
    DEPENDS
        bzip2
        lzo
        xz
        zlib
        zstd
        openssl
        libxml2
    GIT_REPOSITORY https://github.com/libarchive/libarchive.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !doc !libarchive/test libarchive/test/CMakeLists.txt"
    GIT_PROGRESS TRUE
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} sed -i [['/^CHECK_CRYPTO/ { /OPENSSL/!d }']] <SOURCE_DIR>/CMakeLists.txt
    COMMAND ${EXEC} CONF=1 ${CMAKE_COMMAND} -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
        -DENABLE_ZLIB=ON
        -DENABLE_ZSTD=ON
        -DENABLE_OPENSSL=ON
        -DENABLE_BZip2=ON
        -DENABLE_ICONV=ON
        -DENABLE_LIBXML2=ON
        -DENABLE_LZO=ON
        -DENABLE_LZMA=ON
        -DENABLE_EXPAT=OFF
        -DENABLE_PCREPOSIX=OFF
        -DENABLE_PCRE2POSIX=OFF
        -DENABLE_LZ4=OFF
        -DENABLE_LIBB2=OFF
        -DENABLE_CPIO=OFF
        -DENABLE_CNG=OFF
        -DENABLE_CAT=OFF
        -DENABLE_TAR=OFF
        -DENABLE_ACL=OFF
        -DENABLE_WERROR=OFF
        -DENABLE_TEST=OFF
        -DWINDOWS_VERSION=WIN10
        -DPOSIX_REGEX_LIB=OFF
        "-DCMAKE_C_FLAGS='-lxml2 -lbz2 -llzo2 -lz -lbrotlienc -lbrotlidec -lbrotlicommon -lzstd -lws2_32 -lgdi32 -lcrypt32 -liconv -lbcrypt'"
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ${CMAKE_COMMAND} --install <BINARY_DIR>
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libarchive)
cleanup(libarchive install)
