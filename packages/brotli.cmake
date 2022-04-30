ExternalProject_Add(brotli
    GIT_REPOSITORY https://github.com/google/brotli.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DBUILD_SHARED_LIBS=OFF
        -DCMAKE_BUILD_TYPE=Release
        -DBROTLI_EMSCRIPTEN=OFF
    BUILD_COMMAND ${MAKE} -C <BINARY_DIR>
    INSTALL_COMMAND ${MAKE} -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(brotli fix-lib
    DEPENDEES install
    WORKING_DIRECTORY ${MINGW_INSTALL_PREFIX}/lib
    COMMAND mv libbrotlienc-static.a     libbrotlienc.a
    COMMAND mv libbrotlidec-static.a     libbrotlidec.a
    COMMAND mv libbrotlicommon-static.a  libbrotlicommon.a
    COMMAND rm libbrotlicommon.dll.a libbrotlidec.dll.a libbrotlienc.dll.a
)

force_rebuild_git(brotli)
cleanup(brotli fix-lib)
