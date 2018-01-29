ExternalProject_Add(xvidcore
    URL "https://downloads.xvid.com/downloads/xvidcore-1.3.5.tar.gz"
    URL_HASH SHA256=165ba6a2a447a8375f7b06db5a3c91810181f2898166e7c8137401d7fc894cf0
    CONFIGURE_COMMAND ${EXEC} cd <SOURCE_DIR>/build/generic && ./configure # running configure outside that directory will make it happily ignore --host while building
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
    BUILD_COMMAND ${MAKE} -C build/generic BUILD_DIR=build SHARED_LIB=
    INSTALL_COMMAND install -d ${MINGW_INSTALL_PREFIX}/include
        COMMAND install -m644 src/xvid.h ${MINGW_INSTALL_PREFIX}/include/
        COMMAND install -d ${MINGW_INSTALL_PREFIX}/lib
        COMMAND install -m644 build/generic/build/xvidcore.a ${MINGW_INSTALL_PREFIX}/lib/libxvidcore.a
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(xvidcore autoconf
    DEPENDEES download update patch
    DEPENDERS configure
    COMMAND ${EXEC} autoconf
    WORKING_DIRECTORY <SOURCE_DIR>/build/generic
    LOG 1
)

if(${TARGET_CPU} MATCHES "x86_64")
    ExternalProject_Add_Step(xvidcore win64-fix
        DEPENDEES download update patch
        DEPENDERS autoconf
        COMMAND patch -p0 < ${CMAKE_CURRENT_SOURCE_DIR}/xvidcore-2-win64.patch
        WORKING_DIRECTORY <SOURCE_DIR>
    )
endif()

extra_step(xvidcore)
