ExternalProject_Add(icu
    DEPENDS gcc
    URL "http://download.icu-project.org/files/icu4c/62.1/icu4c-62_1-src.tgz"
    URL_HASH SHA256=3dd9868d666350dda66a6e305eecde9d479fb70b30d5b55d78a1deffb97d5aa3
    CONFIGURE_COMMAND ${EXEC} mkdir -p <BINARY_DIR>/native && cd <BINARY_DIR>/native && <SOURCE_DIR>/source/configure CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER}
        COMMAND ${EXEC} cd <BINARY_DIR>/native && make -j${MAKEJOBS}
        COMMAND ${EXEC} <SOURCE_DIR>/source/configure
            --host=${TARGET_ARCH}
            --prefix=${MINGW_INSTALL_PREFIX}
            --with-cross-build=<BINARY_DIR>/native
            --enable-static
            --disable-shared
            CFLAGS="-DU_USING_ICU_NAMESPACE=0 -DU_STATIC_IMPLEMENTATION"
            CXXFLAGS="--std=gnu++0x -DU_STATIC_IMPLEMENTATION"
            SHELL=bash
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
        COMMAND ${CMAKE_COMMAND} -E create_symlink ${MINGW_INSTALL_PREFIX}/bin/icu-config ${CMAKE_INSTALL_PREFIX}/bin/icu-config
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(icu autoreconf
    DEPENDEES download update patch
    DEPENDERS configure
    COMMAND ${EXEC} cd <SOURCE_DIR>/source && autoreconf -fi
    WORKING_DIRECTORY <SOURCE_DIR>/source
)
