ExternalProject_Add(opus-dnn
    URL https://media.xiph.org/opus/models/opus_data-735117b.tar.gz
    URL_HASH SHA256=8f34305a299183509d22c7ba66790f67916a0fc56028ebd4c8f7b938458f2801
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(opus-dnn install)
