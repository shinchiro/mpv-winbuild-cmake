ExternalProject_Add(x265-base
    HG_REPOSITORY https://bitbucket.org/multicoreware/x265
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
)

get_property(source_dir TARGET x265-base PROPERTY _EP_SOURCE_DIR)

ExternalProject_Add(x265-12bit
    DEPENDS
        x265-base
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    SOURCE_DIR ${source_dir}
    CONFIGURE_COMMAND ${CMAKE_COMMAND} <SOURCE_DIR>/source
        -DCMAKE_INSTALL_PREFIX=<BINARY_DIR> -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DHIGH_BIT_DEPTH=ON -DMAIN12=ON -DEXPORT_C_API=OFF -DENABLE_SHARED=OFF -DENABLE_CLI=OFF
    BUILD_COMMAND ${MAKE}
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add(x265-10bit
    DEPENDS
        x265-base
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    SOURCE_DIR ${source_dir}
    CONFIGURE_COMMAND ${CMAKE_COMMAND} <SOURCE_DIR>/source
        -DCMAKE_INSTALL_PREFIX=<BINARY_DIR> -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF -DENABLE_SHARED=OFF -DENABLE_CLI=OFF
    BUILD_COMMAND ${MAKE}
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add(x265
    DEPENDS
        x265-base
        x265-12bit
        x265-10bit
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    SOURCE_DIR ${source_dir}
    PATCH_COMMAND patch -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/x265-0001-extra-libs.patch
    CONFIGURE_COMMAND ${CMAKE_COMMAND} <SOURCE_DIR>/source
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DEXTRA_LINK_FLAGS=-L. -DLINKED_10BIT=ON -DLINKED_12BIT=ON
    BUILD_COMMAND ${MAKE}
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add(x265-10bit-single
    DEPENDS
        x265-base
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    SOURCE_DIR ${source_dir}
    CONFIGURE_COMMAND ${CMAKE_COMMAND} <SOURCE_DIR>/source
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DHIGH_BIT_DEPTH=ON -DENABLE_SHARED=OFF -DSTATIC_LINK_CRT=1
        #-DNATIVE_BUILD=ON
    BUILD_COMMAND ${MAKE}
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

get_property(x265_binary_dir TARGET x265 PROPERTY _EP_BINARY_DIR)

ExternalProject_Add_Step(x265-12bit copy-lib
    DEPENDEES build
    DEPENDERS install
    WORKING_DIRECTORY <BINARY_DIR>
    COMMAND ${CMAKE_COMMAND} -E copy libx265.a ${x265_binary_dir}/libx265_main12.a
    ALWAYS 1
)

ExternalProject_Add_Step(x265-10bit copy-lib
    DEPENDEES build
    DEPENDERS install
    WORKING_DIRECTORY <BINARY_DIR>
    COMMAND ${CMAKE_COMMAND} -E copy libx265.a ${x265_binary_dir}/libx265_main10.a
    ALWAYS 1
)

ExternalProject_Add_Step(x265 rename-lib
    DEPENDEES build
    WORKING_DIRECTORY ${x265_binary_dir}
    COMMAND ${CMAKE_COMMAND} -E copy libx265.a libx265_main.a
)

ExternalProject_Add_Step(x265 combine-libs
    DEPENDEES build rename-lib
    DEPENDERS install
    WORKING_DIRECTORY ${x265_binary_dir}
    COMMAND libtool --mode=link g++ -static -o libx265.a libx265_main.a libx265_main10.a libx265_main12.a
)

extra_step(x265-12bit)
extra_step(x265-10bit)
extra_step(x265)
extra_step(x265-base)
extra_step(x265-10bit-single)
