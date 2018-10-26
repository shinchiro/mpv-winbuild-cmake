ExternalProject_Add(cryptopp
    URL https://github.com/weidai11/cryptopp/archive/CRYPTOPP_7_0_0.tar.gz
    URL_HASH SHA256=3ee97903882b5f58c88b6f9d2ce50fd1000be95479180c7b4681cd3f4c1c7629
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
