# Make it fetch latest tarball release since I'm too lazy to manually change it
set(PREFIX_DIR ${CMAKE_CURRENT_BINARY_DIR}/mpv-release-prefix)
file(WRITE ${PREFIX_DIR}/get_latest_tag.sh
"#!/bin/bash
tag=$(curl -sI https://github.com/mpv-player/mpv/releases/latest | grep 'location: https://github.com/mpv-player/mpv/releases' | sed 's#.*/##g' | tr -d '\r')
printf 'https://github.com/mpv-player/mpv/archive/%s.tar.gz' $tag")

# Workaround since cmake dont allow you to change file permission easily
file(COPY ${PREFIX_DIR}/get_latest_tag.sh
     DESTINATION ${PREFIX_DIR}/src
     FILE_PERMISSIONS OWNER_EXECUTE OWNER_READ)

execute_process(COMMAND ${PREFIX_DIR}/src/get_latest_tag.sh
                OUTPUT_VARIABLE LINK)

# Force the build+install chain to re-run every cmake configure. The workflow
# cleans build_$BIT/mpv* after packaging, which removes the output folder
# (mpv-<TAG>-<arch>/) but leaves ExternalProject stamps intact in the toolchain
# cache. Without this, ninja skips build/copy steps on subsequent runs, leaving
# no folder for the packaging script to archive.
foreach(_stamp build install strip-binary copy-binary copy-versionfile copy-package-dir)
    file(REMOVE ${PREFIX_DIR}/src/mpv-release-stamp/mpv-release-${_stamp})
endforeach()

# Wrapper around `meson setup` that drops any -D<name>=<value> whose <name>
# is not declared in the tarball's meson.options/meson_options.txt. Lets us
# build older stable releases even after master adds new meson options.
file(WRITE ${PREFIX_DIR}/meson_setup_filtered.sh
"#!/bin/bash
set -e
SRC=\"$1\"; shift
BUILD=\"$1\"; shift

OPTS_FILE=\"\"
for f in \"$SRC/meson.options\" \"$SRC/meson_options.txt\"; do
  [ -f \"$f\" ] && { OPTS_FILE=\"$f\"; break; }
done

if [ -z \"$OPTS_FILE\" ]; then
  echo \"meson_setup_filtered.sh: no options file in $SRC; passing through\" >&2
  exec meson setup \"$BUILD\" \"$SRC\" \"$@\"
fi

KNOWN=$(perl -0777 -ne 'while(/option\\s*\\(\\s*[\\x27\\x22]([a-zA-Z0-9_-]+)[\\x27\\x22]/g){print \"$1\\n\"}' \"$OPTS_FILE\")

FILTERED=()
for arg in \"$@\"; do
  if [[ \"$arg\" =~ ^-D([a-zA-Z0-9_-]+)= ]]; then
    name=\"\${BASH_REMATCH[1]}\"
    if ! grep -qx \"$name\" <<< \"$KNOWN\"; then
      echo \"meson_setup_filtered.sh: skipping unsupported -D$name (not in $OPTS_FILE)\" >&2
      continue
    fi
  fi
  FILTERED+=(\"$arg\")
done

exec meson setup \"$BUILD\" \"$SRC\" \"\${FILTERED[@]}\"
")

file(COPY ${PREFIX_DIR}/meson_setup_filtered.sh
     DESTINATION ${PREFIX_DIR}/src
     FILE_PERMISSIONS OWNER_EXECUTE OWNER_READ)

ExternalProject_Add(mpv-release
    DEPENDS
        angle-headers
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
        luajit
        rubberband
        uchardet
        openal-soft
        mujs
        vulkan
        shaderc
        libplacebo
        spirv-cross
        vapoursynth
        libsdl2
        subrandr
        libsixel
    URL ${LINK}
    SOURCE_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ${EXEC} CONF=1 bash ${PREFIX_DIR}/src/meson_setup_filtered.sh <SOURCE_DIR> <BINARY_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --default-library=shared
        --prefer-static
        -Ddebug=true
        -Db_ndebug=true
        -Doptimization=3
        -Db_lto=true
        ${mpv_lto_mode}
        -Dlibmpv=true
        -Dpdf-build=enabled
        -Dlua=enabled
        -Djavascript=enabled
        -Dsdl2-gamepad=enabled
        -Dlibarchive=enabled
        -Dlibbluray=enabled
        -Ddvdnav=enabled
        -Duchardet=enabled
        -Drubberband=enabled
        -Dlcms2=enabled
        -Dopenal=enabled
        -Dspirv-cross=enabled
        -Dvulkan=enabled
        -Dvapoursynth=enabled
        -Dsubrandr=enabled
        -Dsixel=enabled
        ${mpv_gl}
        -Dc_args='-Wno-error=int-conversion'
    BUILD_COMMAND ${EXEC} LTO_JOB=1 ninja -C <BINARY_DIR>
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(mpv-release copy-versionfile
    DEPENDEES download
    DEPENDERS configure
    COMMAND bash -c "cp MPV_VERSION <INSTALL_DIR>/MPV_VERSION"
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)

ExternalProject_Add_Step(mpv-release strip-binary
    DEPENDEES build
    ${mpv_add_debuglink}
    COMMENT "Stripping mpv binaries"
)

ExternalProject_Add_Step(mpv-release copy-binary
    DEPENDEES strip-binary
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.exe                           ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.exe
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.com                           ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.com
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.pdf                           ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/doc/manual.pdf
    COMMAND ${CMAKE_COMMAND} -E copy ${MINGW_INSTALL_PREFIX}/etc/fonts/fonts.conf   ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv/fonts.conf
    COMMENT "Copying mpv binaries and manual"
)

set(RENAME ${CMAKE_CURRENT_BINARY_DIR}/mpv-prefix/src/rename-stable.sh)
file(WRITE ${RENAME}
"#!/bin/bash
cd $1
TAG=$(cat MPV_VERSION)
mv $2 $3/mpv-\${TAG}-$4")

ExternalProject_Add_Step(mpv-release copy-package-dir
    DEPENDEES copy-binary
    COMMAND chmod 755 ${RENAME}
    COMMAND ${RENAME} <SOURCE_DIR> ${CMAKE_CURRENT_BINARY_DIR}/mpv-package ${CMAKE_BINARY_DIR} ${TARGET_CPU}${x86_64_LEVEL}
    COMMENT "Moving mpv package folder"
    LOG 1
)

force_meson_configure(mpv-release)
cleanup(mpv-release copy-package-dir)
