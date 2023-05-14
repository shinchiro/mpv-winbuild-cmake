ExternalProject_Add(rustup
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    SOURCE_DIR rustup-prefix/src
    CONFIGURE_COMMAND ${EXEC}
        curl -sSf https://sh.rustup.rs |
        sh -s -- -y --default-toolchain stable --target x86_64-pc-windows-gnu,i686-pc-windows-gnu --no-modify-path --profile minimal
    BUILD_COMMAND ${EXEC} rustup update
    INSTALL_COMMAND ${EXEC} cargo install cargo-c --profile=release-strip --features=vendored-openssl
    LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(rustup install)
