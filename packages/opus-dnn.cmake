ExternalProject_Add(opus-dnn
    URL https://media.xiph.org/opus/models/opus_data-8a07d57c4fce6fb30f23b3e0d264004e04f1d7b421f5392ef61543d021a439af.tar.gz
    URL_HASH SHA256=8a07d57c4fce6fb30f23b3e0d264004e04f1d7b421f5392ef61543d021a439af
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(opus-dnn install)
