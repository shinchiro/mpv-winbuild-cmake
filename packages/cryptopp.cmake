ExternalProject_Add(cryptopp
    URL https://github.com/weidai11/cryptopp/archive/CRYPTOPP_8_0_0.tar.gz
    URL_HASH SHA256=65e8b7ab068a91427f9ebbdd14ffee2ccfed34defd1902325c87a3eb16efbe6d
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
