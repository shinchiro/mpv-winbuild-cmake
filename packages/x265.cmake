if(${TARGET_CPU} MATCHES "x86_64")
    set(high_bit_depth "-DHIGH_BIT_DEPTH=ON")
    # 10bit/12bit only supported in x64.
else()
    set(high_bit_depth "-DHIGH_BIT_DEPTH=OFF")
endif()

ExternalProject_Add(x265-base
    GIT_REPOSITORY https://bitbucket.org/multicoreware/x265_git.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
)

get_property(source_dir TARGET x265-base PROPERTY _EP_SOURCE_DIR)

ExternalProject_Add(x265-10bit
    DEPENDS
        x265-base
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cmake -H${source_dir}/source -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        ${high_bit_depth}
        -DENABLE_SHARED=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add(x265-12bit-lib
    DEPENDS
        x265-base
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cmake -H${source_dir}/source -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_INSTALL_PREFIX=<BINARY_DIR>
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DHIGH_BIT_DEPTH=ON
        -DMAIN12=ON
        -DEXPORT_C_API=OFF
        -DENABLE_SHARED=OFF
        -DENABLE_CLI=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add(x265-10bit-lib
    DEPENDS
        x265-base
        x265-12bit-lib
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cmake -H${source_dir}/source -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_INSTALL_PREFIX=<BINARY_DIR>
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DHIGH_BIT_DEPTH=ON
        -DEXPORT_C_API=OFF
        -DENABLE_SHARED=OFF
        -DENABLE_CLI=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add(x265-multilibs
    DEPENDS
        x265-base
        x265-12bit-lib
        x265-10bit-lib
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    LIST_SEPARATOR ^^
    CONFIGURE_COMMAND ${EXEC} cmake -H${source_dir}/source -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DEXTRA_LIB='x265_main10.a^^x265_main12.a'
        -DEXTRA_LINK_FLAGS=-L.
        -DLINKED_10BIT=ON
        -DLINKED_12BIT=ON
        -DENABLE_SHARED=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install/strip
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

get_property(multilibs_dir TARGET x265-multilibs PROPERTY _EP_BINARY_DIR)

ExternalProject_Add_Step(x265-12bit-lib copy-lib
    DEPENDEES build
    WORKING_DIRECTORY <BINARY_DIR>
    COMMAND ${CMAKE_COMMAND} -E copy libx265.a ${multilibs_dir}/libx265_main12.a
    ALWAYS 1
)

ExternalProject_Add_Step(x265-10bit-lib copy-lib
    DEPENDEES build
    WORKING_DIRECTORY <BINARY_DIR>
    COMMAND ${CMAKE_COMMAND} -E copy libx265.a ${multilibs_dir}/libx265_main10.a
    ALWAYS 1
)

ExternalProject_Add_Step(x265-multilibs rename-lib
    DEPENDEES build
    WORKING_DIRECTORY ${multilibs_dir}
    COMMAND ${CMAKE_COMMAND} -E copy libx265.a libx265_main.a
)

ExternalProject_Add_Step(x265-multilibs combine-libs
    DEPENDEES build rename-lib
    WORKING_DIRECTORY ${multilibs_dir}
    COMMAND libtool --mode=link g++ -static -o libx265.a libx265_main.a libx265_main10.a libx265_main12.a
    LOG 1
)

extra_step(x265-base)
extra_step(x265-12bit-lib)
extra_step(x265-10bit-lib)
extra_step(x265-multilibs)
extra_step(x265-10bit)
