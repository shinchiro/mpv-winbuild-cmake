ExternalProject_Add(rustup
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    SOURCE_DIR rustup-prefix/src
    CONFIGURE_COMMAND ${EXEC} CONF=1
        curl -sSf https://sh.rustup.rs |
        sh -s -- -y --default-toolchain stable --target aarch64-pc-windows-gnullvm,x86_64-pc-windows-gnullvm,i686-pc-windows-gnullvm,x86_64-pc-windows-gnu,i686-pc-windows-gnu --no-modify-path --profile minimal
    BUILD_COMMAND ${EXEC} rustup update
    INSTALL_COMMAND ${EXEC} LD_PRELOAD= cargo install cargo-c --profile=release-strip --features=vendored-openssl
    LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(rustup install)
