if(${TARGET_CPU} MATCHES "x86_64")
    # allow HEASLR
    set(MPV_LDFLAGS "LDFLAGS=-Wl,--image-base,0x140000000,--high-entropy-va")
    set(MPV_INTERNAL_PTHREADS "--enable-win32-internal-pthreads")
endif()

ExternalProject_Add(mpv
    DEPENDS
        ffmpeg
        fribidi
        lcms2
        libarchive
        libass
        libdvdnav
        libdvdread
        libiconv
        libjpeg
        libpng
        libwaio
        luajit
        rubberband
        uchardet
        winpthreads
	DOWNLOAD_COMMAND git clone git://github.com/mpv-player/mpv.git --depth 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC}
        PKG_CONFIG=pkg-config
        TARGET=${TARGET_ARCH}
        DEST_OS=win32
        ${MPV_LDFLAGS}
        <SOURCE_DIR>/waf configure
        --enable-static-build
        --disable-pdf-build
        --disable-manpage-build
        --disable-debug-build
        --enable-libmpv-shared
        ${MPV_INTERNAL_PTHREADS}
        --enable-waio
        --enable-lua
        --enable-libarchive
        --enable-libass
        --enable-libbluray
        --enable-dvdread
        --enable-dvdnav
        --enable-uchardet
        --enable-rubberband
        --enable-lcms2
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
    COMMAND ${EXEC} ${TARGET_ARCH}-objcopy --only-keep-debug <SOURCE_DIR>/build/mpv.exe <SOURCE_DIR>/build/mpv.exe.debug
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <SOURCE_DIR>/build/mpv.exe
    COMMAND ${EXEC} ${TARGET_ARCH}-objcopy --add-gnu-debuglink=<SOURCE_DIR>/build/mpv.exe.debug <SOURCE_DIR>/build/mpv.exe

    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <SOURCE_DIR>/build/mpv.com

    COMMAND ${EXEC} ${TARGET_ARCH}-objcopy --only-keep-debug <SOURCE_DIR>/build/mpv-1.dll <SOURCE_DIR>/build/mpv-1.dll.debug
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -g <SOURCE_DIR>/build/mpv-1.dll
    COMMAND ${EXEC} ${TARGET_ARCH}-objcopy --add-gnu-debuglink=<SOURCE_DIR>/build/mpv-1.dll.debug <SOURCE_DIR>/build/mpv-1.dll
    COMMENT "Stripping mpv binaries"
)

ExternalProject_Add_Step(mpv clean-package-dir
    DEPENDEES build
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_CURRENT_BINARY_DIR}/mpv-package
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/mpv-package
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev
)

ExternalProject_Add_Step(mpv copy-binary
    DEPENDEES strip-binary clean-package-dir
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv.exe ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.exe

    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv.exe.debug ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/mpv.exe.debug
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv-1.dll ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/mpv-1.dll
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv-1.dll.debug ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/mpv-1.dll.debug
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/libmpv.dll.a ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/libmpv.dll.a

    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv.com ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.com
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/DOCS/man/mpv.pdf ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/manual.pdf
    COMMENT "Copying mpv binaries and manual"
)

if(${TARGET_CPU} MATCHES "i686")
    ExternalProject_Add_Step(mpv copy-font-stuff
        DEPENDEES clean-package-dir
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/mpv/mpv ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/fonts
        COMMENT "Copying font stuff"
    )
endif()

ExternalProject_Add_Step(mpv pack-binary
    DEPENDEES copy-binary copy-font-stuff
    COMMAND ${CMAKE_COMMAND} -E remove ../../mpv-${TARGET_CPU}-${BUILDDATE}.7z
    COMMAND ${EXEC} 7z a -m0=lzma2 -mx=9 -ms=on ../../mpv-${TARGET_CPU}-${BUILDDATE}.7z *
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mpv-package
    COMMENT "Packing mpv binary"
    LOG 1
)

if(${TARGET_CPU} MATCHES "i686")
    ExternalProject_Add_Step(mpv download-font
        DEPENDEES copy-font-stuff
        DEPENDERS pack-binary
        COMMAND wget "http://srsfckn.biz/noto-mpv.7z"
        COMMAND 7z x noto-mpv.7z
        COMMAND ${CMAKE_COMMAND} -E remove noto-mpv.7z
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/fonts
        LOG 1
    )
endif()
