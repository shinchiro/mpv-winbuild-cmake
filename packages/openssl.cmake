ExternalProject_Add(openssl
    DEPENDS
        zlib
        zstd
        brotli
    GIT_REPOSITORY https://github.com/openssl/openssl.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--depth=1 --sparse --filter=tree:0"
    GIT_PROGRESS TRUE
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !test"
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/openssl-arm64.conf <SOURCE_DIR>/Configurations/11-mingw-arm64.conf
    COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/Configure
        --cross-compile-prefix=${TARGET_ARCH}-
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=lib
        --release
        enable-ec_nistp_64_gcc_128
        no-tls-deprecated-ec
        no-autoload-config
        ${openssl_target}
        no-ssl3-method
        enable-brotli
        no-whirlpool
        no-filenames
        no-camellia
        enable-zstd
        no-capieng
        no-shared
        no-rmd160
        no-module
        no-legacy
        no-engine
        no-tests
        threads
        no-docs
        no-apps
        no-ocsp
        no-ssl3
        no-cmac
        no-mdc2
        no-idea
        no-cast
        no-srtp
        no-seed
        no-aria
        no-err
        no-dso
        no-dsa
        no-srp
        no-rc2
        no-rc4
        no-sm2
        no-sm3
        no-sm4
        no-md4
        no-cms
        no-cmp
        no-dh
        no-bf
        zlib
    BUILD_COMMAND ${MAKE} build_sw
    INSTALL_COMMAND ${MAKE} install_sw
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(openssl)
cleanup(openssl install)
