ExternalProject_Add(cryptopp
    URL https://github.com/weidai11/cryptopp/archive/CRYPTOPP_8_2_0.tar.gz
    URL_HASH SHA256=e3bcd48a62739ad179ad8064b523346abb53767bcbefc01fe37303412292343e
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE}
        CXX=${TARGET_ARCH}-g++
        CC=${TARGET_ARCH}-gcc
        AR=${TARGET_ARCH}-ar
        RANLIB=${TARGET_ARCH}-ranlib
    INSTALL_COMMAND ${MAKE}
        PREFIX=${MINGW_INSTALL_PREFIX}
        install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(cryptopp)
