ExternalProject_Add(mpv
    DEPENDS
        ffmpeg
        fribidi
        libass
        libiconv
        libjpeg
        libpng
        libquvi
        openal-soft
        portaudio
        winpthreads
    GIT_REPOSITORY git://github.com/mpv-player/mpv.git
    #GIT_TAG lua_experiment
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --target=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --windres=${TARGET_ARCH}-windres
        "--pkg-config='pkg-config --static'"
        --enable-cross-compile
        --enable-static
        --enable-openal
        --disable-sdl2
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ""
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

file(DOWNLOAD "https://github.com/android/platform_frameworks_base/raw/master/data/fonts/DroidSansFallbackFull.ttf" ${CMAKE_CURRENT_BINARY_DIR}/DroidSansFallbackFull.ttf SHOW_PROGRESS)

ExternalProject_Add_Step(mpv strip-binary
    DEPENDEES build
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <SOURCE_DIR>/mpv.exe
    COMMENT "Stripping mpv binary"
)

ExternalProject_Add_Step(mpv copy-binary
    DEPENDEES strip-binary
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/mpv.exe ${CMAKE_CURRENT_BINARY_DIR}/mpv.exe
    COMMENT "Copying mpv binary"
)

ExternalProject_Add_Step(mpv copy-libquvi-scripts
    DEPENDEES build
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_CURRENT_BINARY_DIR}/libquvi-scripts
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${MINGW_INSTALL_PREFIX}/share/libquvi-scripts ${CMAKE_CURRENT_BINARY_DIR}/libquvi-scripts
    COMMENT "Copying libquvi scripts"
)

ExternalProject_Add_Step(mpv copy-font-stuff
    DEPENDEES build
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_CURRENT_BINARY_DIR}/mpv
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_CURRENT_BINARY_DIR}/fonts
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/mpv ${CMAKE_CURRENT_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/fonts
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/DroidSansFallbackFull.ttf ${CMAKE_CURRENT_BINARY_DIR}/fonts/DroidSansFallbackFull.ttf
    COMMENT "Copying font stuff"
)

ExternalProject_Add_Step(mpv pack-binary
    DEPENDEES copy-binary copy-libquvi-scripts copy-font-stuff
    COMMAND ${CMAKE_COMMAND} -E remove ../mpv-${TARGET_CPU}-${BUILDDATE}.7z
    COMMAND 7z a -m0=lzma2 -mx=9 -ms=on ../mpv-${TARGET_CPU}-${BUILDDATE}.7z mpv.exe libquvi-scripts fonts fonts.conf
    COMMENT "Packing mpv binary"
)

