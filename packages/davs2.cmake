if(${TARGET_CPU} MATCHES "i686")
    set(disable_asm "--disable-asm")
endif()

set(davs2_patch_root "${CMAKE_CURRENT_SOURCE_DIR}/patches/davs2-10bit")

ExternalProject_Add(davs2
    GIT_REPOSITORY https://github.com/xatabhk/davs2-10bit.git
    GIT_TAG 21d64c8f8e36af71fc7a488cd6f789c86cdd1200
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} bash ${PROJECT_SOURCE_DIR}/scripts/apply_davs2_patches.sh <SOURCE_DIR> ${davs2_patch_root} ${TARGET_CPU_FAMILY}
    CONFIGURE_COMMAND ${EXEC} cd <SOURCE_DIR>/build/linux && CONF=1 ./configure
        --host=${TARGET_ARCH}
        --cross-prefix=${TARGET_CPU}-w64-mingw32-
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-cli
        ${disable_asm}
    BUILD_COMMAND ${MAKE} -C <SOURCE_DIR>/build/linux
    INSTALL_COMMAND ${MAKE} -C <SOURCE_DIR>/build/linux install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(davs2)
cleanup(davs2 install)
