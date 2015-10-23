if(${TARGET_CPU} MATCHES "i686")
    set(ASS_USE_FONTCONFIG fontconfig)
else()
    set(ASS_DISABLE_FONTCONFIG "--disable-fontconfig")
endif()

ExternalProject_Add(libass
    DEPENDS
        harfbuzz
        freetype2
        ${ASS_USE_FONTCONFIG}
        fribidi
        libiconv
    DOWNLOAD_COMMAND git clone https://github.com/libass/libass.git --depth 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        ${ASS_DISABLE_FONTCONFIG}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libass)
autogen(libass)
