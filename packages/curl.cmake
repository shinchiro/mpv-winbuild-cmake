ExternalProject_Add(curl
    DEPENDS
        libressl
    GIT_REPOSITORY https://github.com/curl/curl.git
    GIT_SHALLOW 1
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/curl-*.patch
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(curl)
autoreconf(curl)
extra_step(curl)

# Download the cacert.pem file: https://curl.haxx.se/docs/caextract.html
# Rename the cacert.pem file to curl-ca-bundle.crt
# Put in same directory as curl.exe
