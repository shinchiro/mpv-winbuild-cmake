ExternalProject_Add(rustup
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    SOURCE_DIR rustup-prefix/src
    CONFIGURE_COMMAND ${EXEC} CONF=1
        curl -sSf https://sh.rustup.rs |
        sh -s -- -y --default-toolchain nightly --no-modify-path --profile minimal
    BUILD_COMMAND ${EXEC} rustup update
          COMMAND ${EXEC} rustup component add rust-src
    INSTALL_COMMAND ${EXEC} cargo install cargo-c --profile=release-strip --features=vendored-openssl
    LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(rustup install)
