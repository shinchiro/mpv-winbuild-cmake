ExternalProject_Add(xvidcore
    URL "https://downloads.xvid.com/downloads/xvidcore-1.3.7.tar.bz2"
    URL_HASH SHA256=aeeaae952d4db395249839a3bd03841d6844843f5a4f84c271ff88f7aa1acff7
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ${EXEC} cd <SOURCE_DIR>/build/generic && CONF=1 ./configure # running configure outside that directory will make it happily ignore --host while building
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-assembly
    BUILD_COMMAND ${MAKE} -C build/generic BUILD_DIR=build SHARED_LIB=
    INSTALL_COMMAND install -d ${MINGW_INSTALL_PREFIX}/include
        COMMAND install -m644 src/xvid.h ${MINGW_INSTALL_PREFIX}/include/
        COMMAND install -d ${MINGW_INSTALL_PREFIX}/lib
        COMMAND install -m644 build/generic/build/xvidcore.a ${MINGW_INSTALL_PREFIX}/lib/libxvidcore.a
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(xvidcore autoconf
    DEPENDEES download update
    DEPENDERS configure
    COMMAND ${EXEC} autoconf
    WORKING_DIRECTORY <SOURCE_DIR>/build/generic
    LOG 1
)

cleanup(xvidcore install)
