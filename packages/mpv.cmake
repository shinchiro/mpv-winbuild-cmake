ExternalProject_Add(mpv
    DEPENDS
        enca
        ffmpeg
        fribidi
        lcms2
        libass
        libiconv
        libjpeg
        libpng
        libquvi
        openal-soft
        portaudio
        winpthreads
    GIT_REPOSITORY git://github.com/mpv-player/mpv.git
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC}
        PKG_CONFIG=pkg-config
        TARGET=${TARGET_ARCH}
        DEST_OS=win32
        <SOURCE_DIR>/waf configure
        --enable-static-build
        --enable-openal
        --enable-pdf-build
        --prefix=${MINGW_INSTALL_PREFIX}
    BUILD_COMMAND ${EXEC} <SOURCE_DIR>/waf
    INSTALL_COMMAND ""
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(mpv)

ExternalProject_Add_Step(mpv bootstrap
    DEPENDEES download
    DEPENDERS configure
    COMMAND <SOURCE_DIR>/bootstrap.py
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)

ExternalProject_Add_Step(mpv strip-binary
    DEPENDEES build
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <SOURCE_DIR>/build/mpv.exe
    COMMENT "Stripping mpv binary"
)

ExternalProject_Add_Step(mpv copy-binary
    DEPENDEES strip-binary
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv.exe ${CMAKE_CURRENT_BINARY_DIR}/mpv.exe
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
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/mpv/mpv ${CMAKE_CURRENT_BINARY_DIR}/mpv
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/fonts
    COMMENT "Copying font stuff"
)

ExternalProject_Add_Step(mpv pack-binary
    DEPENDEES copy-binary copy-libquvi-scripts copy-font-stuff
    COMMAND ${CMAKE_COMMAND} -E remove ../mpv-${TARGET_CPU}-${BUILDDATE}.7z
    COMMAND 7z a -m0=lzma2 -mx=9 -ms=on ../mpv-${TARGET_CPU}-${BUILDDATE}.7z mpv.exe libquvi-scripts mpv fonts
    COMMENT "Packing mpv binary"
    LOG 1
)

ExternalProject_Add_Step(mpv download-font
    DEPENDEES copy-font-stuff
    DEPENDERS pack-binary
    COMMAND wget "https://github.com/android/platform_frameworks_base/raw/master/data/fonts/DroidSansFallbackFull.ttf"
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/fonts
    LOG 1
)
