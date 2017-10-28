if(${TARGET_CPU} MATCHES "x86_64")
    set(target "x64")
else()
    set(target "x86")
endif()

ExternalProject_Add(angle
    GIT_REPOSITORY https://chromium.googlesource.com/angle/angle
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am ${CMAKE_CURRENT_SOURCE_DIR}/angle-*.patch
    CONFIGURE_COMMAND gyp -Duse_ozone=0 -DOS=win -Dangle_gl_library_type=static_library
        -Dangle_use_commit_id=1 --depth . -I gyp/common.gypi src/angle.gyp --no-parallel
        --format=make --generator-output=build -Dangle_enable_vulkan=0 -Dtarget_cpu=${target}
    BUILD_COMMAND ""
    INSTALL_COMMAND ${MAKE}
        PREFIX=${MINGW_INSTALL_PREFIX}
        install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(angle make-commitid
    DEPENDEES configure
    WORKING_DIRECTORY <SOURCE_DIR>/build
    COMMAND ${MAKE} commit_id
    LOG 1
)

ExternalProject_Add_Step(angle copy-commitid
    DEPENDEES make-commitid
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/out/Debug/obj/gen/angle/id/commit.h <SOURCE_DIR>/src/id/commit.h
)

ExternalProject_Add_Step(angle make-all
    DEPENDEES copy-commitid
    WORKING_DIRECTORY <SOURCE_DIR>/build
    COMMAND ${MAKE}
        CXX=${TARGET_ARCH}-g++
        AR=${TARGET_ARCH}-ar
        RANLIB=${TARGET_ARCH}-ranlib
        BUILDTYPE=Release
    LOG 1
)

ExternalProject_Add_Step(angle move-libs
    DEPENDEES make-all
    DEPENDERS install
    COMMAND ${EXEC} <SOURCE_DIR>/move-libs.sh ${TARGET_ARCH}
)

force_rebuild_git(angle)
extra_step(angle)

# This is too confusing
# DEPENDEES: Steps on which this step depends
# DEPENDERS: Steps that depend on this step
