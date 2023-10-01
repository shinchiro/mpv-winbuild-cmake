# CMake-based MinGW-w64 Cross Toolchain

This thing’s primary use is to build Windows binaries of mpv.

Alternatively, you can download the builds from [here](https://sourceforge.net/projects/mpv-player-windows/files/).

## Prerequisites

 -  You should also install Ninja and use CMake’s Ninja build file generator.
    It’s not only much faster than GNU Make, but also far less error-prone,
    which is important for this project because CMake’s ExternalProject module
    tends to generate makefiles which confuse GNU Make’s jobserver thingy.

 -  As a build environment, any modern Linux distribution *should* work.

-   Compiling on Cygwin / MSYS2 is supported, but it tends to be slower
    than compiling on Linux.

## Setup Build Environment
### Manjaro / Arch Linux

These packages need to be installed first before compiling mpv:

    pacman -S git gyp mercurial subversion ninja cmake meson ragel yasm nasm asciidoc enca gperf unzip p7zip gcc-multilib clang lld libc++ libc++abi python-pip curl lib32-glib2

    pip3 install rst2pdf mako jsonschema

### Ubuntu Linux / WSL (Windows 10)

    apt-get install build-essential checkinstall bison flex gettext git mercurial subversion ninja-build gyp cmake yasm nasm automake pkgconf libtool libtool-bin gcc-multilib g++-multilib clang lld libc++1 libc++abi1 libgmp-dev libmpfr-dev libmpc-dev libgcrypt-dev gperf ragel texinfo autopoint re2c asciidoc python3-pip docbook2x unzip p7zip-full curl

    pip3 install rst2pdf meson mako jsonschema

**Note:**

* Use [apt-fast](https://github.com/ilikenwf/apt-fast) if apt-get is too slow.
* It is advised to use bash over dash. Set `sudo ln -sf /bin/bash /bin/sh`. Revert back by `sudo ln -sf /bin/dash /bin/sh`.
* On WSL platform, compiling 32bit requires qemu. Refer to [this](https://github.com/Microsoft/WSL/issues/2468#issuecomment-374904520).
* To update package installed by pip, run `pip3 install <package> --upgrade`.

### Cygwin

Download Cygwin installer and run:

    setup-x86_64.exe -R "C:\cygwin64" -q --packages="bash,binutils,bzip2,cygwin,gcc-core,gcc-g++,cygwin32-gcc-core,cygwin32-gcc-g++,gzip,m4,pkgconf,make,unzip,zip,diffutils,wget,git,patch,cmake,gperf,yasm,enca,asciidoc,bison,flex,gettext-devel,mercurial,python-devel,python-docutils,docbook2X,texinfo,libmpfr-devel,libgmp-devel,libmpc-devel,libtool,autoconf2.5,automake,automake1.9,libxml2-devel,libxslt-devel,meson,libunistring5"

Additionally, some packages, `re2c`, `ninja`, `ragel`, `gyp`, `rst2pdf`, `nasm` need to be [installed manually](https://gist.github.com/shinchiro/705b0afcc7b6c0accffba1bedb067abf).

### MSYS2

Install MSYS2 and run it via `MSYS2 MSYS` shortcut.
Don't use `MSYS2 MinGW 32-bit` or `MSYS2 MinGW 64-bit` shortcuts, that's important!

These packages need to be installed first before compiling mpv:

    pacman -S base-devel cmake gcc yasm nasm git mercurial subversion gyp tar gmp-devel mpc-devel mpfr-devel python zlib-devel unzip zip p7zip meson libunistring5

Don't install anything from the `mingw32` and `mingw64` repositories,
it's better to completely disable them in `/etc/pacman.conf` just to be safe.

Additionally, some packages, `re2c`, `ninja`, `ragel`, `libjpeg`, `rst2pdf`, `jinja2` need to be [installed manually](https://gist.github.com/shinchiro/705b0afcc7b6c0accffba1bedb067abf).


## Compiling with GCC

Example:

    cmake -DTARGET_ARCH=x86_64-w64-mingw32 \
    -DGCC_ARCH=x86-64-v3 \
    -DALWAYS_REMOVE_BUILDFILES=ON \
    -DSINGLE_SOURCE_LOCATION="/home/shinchiro/packages" \
    -DRUSTUP_LOCATION="/home/shinchiro/install_rustup" \
    -G Ninja -B build64 -S mpv-winbuild-cmake

This cmake command will create `build64` folder for `x86_64-w64-mingw32`. Set `-DTARGET_ARCH=i686-w64-mingw32` for compiling 32-bit.

`-DGCC_ARCH=x86-64-v3` will set `-march` option when compiling gcc with `x86-64-v3` instructions. Other value like `native`, `znver3` should work too.

Enter `build64` folder and build toolchain once. By default, it will be installed in `install` folder.

    ninja download # download all packages at once (optional)
    ninja gcc      # build gcc only once (take around ~20 minutes)
    ninja mpv      # build mpv and all its dependencies

On **WSL2**, you might see it stuck with 100% disk usage and never finished. See [below](#wsl-workaround).

The final `build64` folder's size will be around ~3GB.

## Building Software (Second Time)

To build mpv for a second time:

    ninja update # perform git pull on all packages that used git

After that, build mpv as usual:

    ninja mpv

## Compiling with Clang

Supported target architecture (`TARGET_ARCH`) with clang is: `x86_64-w64-mingw32` , `i686-w64-mingw32` , `aarch64-w64-mingw32`. The `aarch64` are untested.

Example:

    cmake -DTARGET_ARCH=x86_64-w64-mingw32 \
    -DCMAKE_INSTALL_PREFIX="/home/anon/clang_root" \
    -DCOMPILER_TOOLCHAIN=clang \
    -DGCC_ARCH=x86-64-v3 \
    -DALWAYS_REMOVE_BUILDFILES=ON \
    -DSINGLE_SOURCE_LOCATION="/home/anon/packages" \
    -DRUSTUP_LOCATION="/home/anon/install_rustup" \
    -DMINGW_INSTALL_PREFIX="/home/anon/build_x86_64_v3/x86_64_v3-w64-mingw32" \
    -G Ninja -B build_x86_64_v3 -S mpv-winbuild-cmake

The cmake command will create `clang_root` as clang sysroot where llvm tools installed. `build_x86_64` is build directory to compiling packages.

    cd build_x86_64
    ninja llvm       # build LLVM (take around ~2 hours)
    ninja rustup     # build rust toolchain
    ninja llvm-clang # build clang on specified target
    ninja mpv        # build mpv and all its dependencies

If you want add another target (ex. `i686-w64-mingw32`), change `TARGET_ARCH` and build folder.

    cmake -DTARGET_ARCH=i686-w64-mingw32 \
    -DCMAKE_INSTALL_PREFIX="/home/anon/clang_root" \
    -DCOMPILER_TOOLCHAIN=clang \
    -DALWAYS_REMOVE_BUILDFILES=ON \
    -DSINGLE_SOURCE_LOCATION="/home/anon/packages" \
    -DRUSTUP_LOCATION="/home/anon/install_rustup" \
    -DMINGW_INSTALL_PREFIX="/home/anon/build_i686/i686-w64-mingw32" \
    -G Ninja -B build_i686 -S mpv-winbuild-cmake
    cd build_i686
    ninja llvm-clang # same as above

If you've changed `GCC_ARCH` option, you need to run:

    ninja rebuild_cache

to update flags which will pass on gcc, g++ and etc.

## Available Commands

| Commands                   | Description |
| -------------------------- | ----------- |
| ninja package              | compile a package |
| ninja clean                | remove all stamp files in all packages. |
| ninja download             | Download all packages' sources at once without compiling. |
| ninja update               | Update all git repos. When a package pulls new changes, all of its stamp files will be deleted and will be forced rebuild. If there is no change, it will not remove the stamp files and no rebuild occur. Use this instead of `ninja clean` if you don't want to rebuild everything in the next run. |
| ninja package-fullclean    | Remove all stamp files of a package. |
| ninja package-liteclean    | Remove build, clean stamp files only. This will skip re-configure in the next running `ninja package` (after the first compile). Updating repo or patching need to do manually. Ideally, all `DEPENDS` targets in `package.cmake` should be temporarily commented or deleted. Might be useful in some cases. |
| ninja package-removebuild  | Remove 'build' directory of a package. |
| ninja package-removeprefix | Remove 'prefix' directory. |
| ninja package-force-update | Update a package. Only git repo will be updated. |

`package` is package's name found in `packages` folder.

## Information about packages

- Git/Hg
    - ANGLE [![ANGLE](https://flat.badgen.net/gitlab/last-commit/shinchiro/angle/main?scale=0.8&cache=1800)](https://gitlab.com/shinchiro/angle)
    - FFmpeg [![FFmpeg](https://flat.badgen.net/github/last-commit/FFmpeg/FFmpeg?scale=0.8&cache=1800)](https://github.com/FFmpeg/FFmpeg)
    - xz [![xz](https://flat.badgen.net/gitlab/last-commit/shinchiro/xz?scale=0.8&cache=1800)](https://gitlab.com/shinchiro/xz)
    - x264 [![x264](https://flat.badgen.net/https/latest-commit-badgen.vercel.app/gitlab/code.videolan.org/videolan/x264?scale=0.8&cache=1800)](https://code.videolan.org/videolan/x264)
    - x265 (multilib) [![x265](https://flat.badgen.net/https/latest-commit-badgen.vercel.app/bitbucket/multicoreware/x265_git?scale=0.8&cache=1800)](https://bitbucket.org/multicoreware/x265_git)
    - uchardet [![uchardet](https://flat.badgen.net/https/latest-commit-badgen.vercel.app/gitlab/gitlab.freedesktop.org/uchardet/uchardet?scale=0.8&cache=1800)](https://gitlab.freedesktop.org/uchardet/uchardet)
    - rubberband [![rubberband](https://flat.badgen.net/github/last-commit/breakfastquay/rubberband/default?scale=0.8&cache=1800)](https://github.com/breakfastquay/rubberband)
    - opus [![opus](https://flat.badgen.net/github/last-commit/xiph/opus?scale=0.8&cache=1800)](https://github.com/xiph/opus)
    - openal-soft [![openal-soft](https://flat.badgen.net/github/last-commit/kcat/openal-soft?scale=0.8&cache=1800)](https://github.com/kcat/openal-soft)
    - mpv [![mpv](https://flat.badgen.net/github/last-commit/mpv-player/mpv?scale=0.8&cache=1800)](https://github.com/mpv-player/mpv)
    - luajit [![luajit](https://flat.badgen.net/github/last-commit/openresty/luajit2/v2.1-agentzh?scale=0.8&cache=1800)](https://github.com/openresty/luajit2)
    - libvpx [![libvpx](https://flat.badgen.net/github/last-commit/webmproject/libvpx/main?scale=0.8&cache=1800)](https://chromium.googlesource.com/webm/libvpx)
    - libwebp [![libwebp](https://flat.badgen.net/github/last-commit/webmproject/libwebp/main?scale=0.8&cache=1800)](https://chromium.googlesource.com/webm/libwebp)
    - libpng [![libpng](https://flat.badgen.net/github/last-commit/glennrp/libpng?scale=0.8&cache=1800)](https://github.com/glennrp/libpng)
    - libsoxr [![libsoxr](https://flat.badgen.net/gitlab/last-commit/shinchiro/soxr?scale=0.8&cache=1800)](https://gitlab.com/shinchiro/soxr)
    - libzimg (with [graphengine](https://github.com/sekrit-twc/graphengine)) [![libzimg](https://flat.badgen.net/github/last-commit/sekrit-twc/zimg?scale=0.8&cache=1800)](https://github.com/sekrit-twc/zimg)
    - libdvdread [![libdvdread](https://flat.badgen.net/https/latest-commit-badgen.vercel.app/gitlab/code.videolan.org/videolan/libdvdread?scale=0.8&cache=1800)](https://code.videolan.org/videolan/libdvdread)
    - libdvdnav [![libdvdnav](https://flat.badgen.net/https/latest-commit-badgen.vercel.app/gitlab/code.videolan.org/videolan/libdvdnav?scale=0.8&cache=1800)](https://code.videolan.org/videolan/libdvdnav)
    - libdvdcss [![libdvdcss](https://flat.badgen.net/https/latest-commit-badgen.vercel.app/gitlab/code.videolan.org/videolan/libdvdcss?scale=0.8&cache=1800)](https://code.videolan.org/videolan/libdvdcss)
    - libudfread [![libdvdcss](https://flat.badgen.net/https/latest-commit-badgen.vercel.app/gitlab/code.videolan.org/videolan/libudfread?scale=0.8&cache=1800)](https://code.videolan.org/videolan/libudfread)
    - libbluray [![libbluray](https://flat.badgen.net/https/latest-commit-badgen.vercel.app/gitlab/code.videolan.org/videolan/libbluray?scale=0.8&cache=1800)](https://code.videolan.org/videolan/libbluray)
    - libunibreak [![libunibreak](https://flat.badgen.net/github/last-commit/adah1972/libunibreak?scale=0.8&cache=1800)](https://github.com/adah1972/libunibreak)
    - libass [![libass](https://flat.badgen.net/github/last-commit/libass/libass?scale=0.8&cache=1800)](https://github.com/libass/libass)
    - libmysofa [![libmysofa](https://flat.badgen.net/github/last-commit/hoene/libmysofa/main?scale=0.8&cache=1800)](https://github.com/hoene/libmysofa)
    - lcms2 [![lcms2](https://flat.badgen.net/github/last-commit/mm2/Little-CMS?scale=0.8&cache=1800)](https://github.com/mm2/Little-CMS)
    - lame [![lame](https://flat.badgen.net/gitlab/last-commit/shinchiro//lame?scale=0.8&cache=1800)](https://gitlab.com/shinchiro/lame)
    - harfbuzz [![harfbuzz](https://flat.badgen.net/github/last-commit/harfbuzz/harfbuzz/main?scale=0.8&cache=1800)](https://github.com/harfbuzz/harfbuzz)
    - game-music-emu [![game-music-emu](https://flat.badgen.net/https/latest-commit-badgen.vercel.app/bitbucket/mpyne/game-music-emu?scale=0.8&cache=1800)](https://bitbucket.org/mpyne/game-music-emu)
    - freetype2 [![freetype2](https://flat.badgen.net/gitlab/last-commit/shinchiro/freetype2?scale=0.8&cache=1800)](https://gitlab.com/shinchiro/freetype2)
    - flac [![flac](https://flat.badgen.net/github/last-commit/xiph/flac?scale=0.8&cache=1800)](https://github.com/xiph/flac)
    - opus-tools [![opus-tools](https://flat.badgen.net/github/last-commit/xiph/opus-tools?scale=0.8&cache=1800)](https://github.com/xiph/opus-tools)
    - mujs [![mujs](https://flat.badgen.net/github/last-commit/ccxvii/mujs?scale=0.8&cache=1800)](https://github.com/ccxvii/mujs)
    - libarchive [![libarchive](https://flat.badgen.net/github/last-commit/libarchive/libarchive?scale=0.8&cache=1800)](https://github.com/libarchive/libarchive)
    - libjpeg [![libjpeg](https://flat.badgen.net/github/last-commit/libjpeg-turbo/libjpeg-turbo/main?scale=0.8&cache=1800)](https://github.com/libjpeg-turbo/libjpeg-turbo)
    - shaderc (with [spirv-headers](https://github.com/KhronosGroup/SPIRV-Headers), [spirv-tools](https://github.com/KhronosGroup/SPIRV-Tools), [glslang](https://github.com/KhronosGroup/glslang)) [![shaderc](https://flat.badgen.net/github/last-commit/google/shaderc/main?scale=0.8&cache=1800)](https://github.com/google/shaderc)
    - vulkan-header [![Vulkan-Headers](https://flat.badgen.net/github/last-commit/KhronosGroup/Vulkan-Headers/main?scale=0.8&cache=1800)](https://github.com/KhronosGroup/Vulkan-Headers)
    - vulkan [![Vulkan](https://flat.badgen.net/github/last-commit/KhronosGroup/Vulkan-Loader/main?scale=0.8&cache=1800)](https://github.com/KhronosGroup/Vulkan-Loader)
    - spirv-cross [![spirv-cross](https://flat.badgen.net/github/last-commit/KhronosGroup/SPIRV-Cross/main?scale=0.8&cache=1800)](https://github.com/KhronosGroup/SPIRV-Cross)
    - fribidi [![fribidi](https://flat.badgen.net/github/last-commit/fribidi/fribidi?scale=0.8&cache=1800)](https://github.com/fribidi/fribidi)
    - nettle [![nettle](https://flat.badgen.net/gitlab/last-commit/shinchiro/nettle?scale=0.8&cache=1800)](https://gitlab.com/shinchiro/nettle)
    - curl [![curl](https://flat.badgen.net/github/last-commit/curl/curl?scale=0.8&cache=1800)](https://github.com/curl/curl)
    - libxml2 [![libxml2](https://flat.badgen.net/https/latest-commit-badgen.vercel.app/gitlab/gitlab.gnome.org/GNOME/libxml2?scale=0.8&cache=1800)](https://gitlab.gnome.org/GNOME/libxml2)
    - amf-headers [![amf-headers](https://flat.badgen.net/github/last-commit/GPUOpen-LibrariesAndSDKs/AMF?scale=0.8&cache=1800)](https://github.com/GPUOpen-LibrariesAndSDKs/AMF/tree/master/amf/public/include)
    - avisynth-headers [![avisynth-headers](https://flat.badgen.net/github/last-commit/AviSynth/AviSynthPlus?scale=0.8&cache=1800)](https://github.com/AviSynth/AviSynthPlus)
    - nvcodec-headers [![nvcodec-headers](https://flat.badgen.net/github/last-commit/FFmpeg/nv-codec-headers?scale=0.8&cache=1800)](https://git.videolan.org/?p=ffmpeg/nv-codec-headers.git)
    - libvpl [![libvpl](https://flat.badgen.net/github/last-commit/oneapi-src/oneVPL?scale=0.8&cache=1800)](https://github.com/oneapi-src/oneVPL)
    - megasdk (with termcap, readline, cryptopp, sqlite, libuv, libsodium)
    - aom [![aom](https://flat.badgen.net/github/last-commit/m-ab-s/aom?scale=0.8&cache=1800)](https://github.com/m-ab-s/aom)
    - dav1d [![dav1d](https://flat.badgen.net/https/latest-commit-badgen.vercel.app/gitlab/code.videolan.org/videolan/dav1d?scale=0.8&cache=1800)](https://code.videolan.org/videolan/dav1d/)
    - libplacebo (with [glad](https://github.com/Dav1dde/glad), [fast_float](https://github.com/fastfloat/fast_float), [xxhash](https://github.com/Cyan4973/xxHash)) [![libplacebo](https://flat.badgen.net/github/last-commit/haasn/libplacebo?scale=0.8&cache=1800)](https://github.com/haasn/libplacebo)
    - fontconfig [![uchardet](https://flat.badgen.net/https/latest-commit-badgen.vercel.app/gitlab/gitlab.freedesktop.org/fontconfig/fontconfig?scale=0.8&cache=1800)](https://gitlab.freedesktop.org/fontconfig/fontconfig)
    - libbs2b [![libbs2b](https://flat.badgen.net/github/last-commit/alexmarsev/libbs2b?scale=0.8&cache=1800)](https://github.com/alexmarsev/libbs2b)
    - libssh [libssh](https://git.libssh.org/projects/libssh.git)
    - libsrt [![libsrt](https://flat.badgen.net/github/last-commit/Haivision/srt?scale=0.8&cache=1800)](https://github.com/Haivision/srt)
    - libjxl (with [brotli](https://github.com/google/brotli), [highway](https://github.com/google/highway)) [![libjxl](https://flat.badgen.net/github/last-commit/libjxl/libjxl/main?scale=0.8&cache=1800)](https://github.com/libjxl/libjxl)
    - libmodplug [![libmodplug](https://flat.badgen.net/github/last-commit/Konstanty/libmodplug?scale=0.8&cache=1800)](https://github.com/Konstanty/libmodplug)
    - uavs3d [![uavs3d](https://flat.badgen.net/github/last-commit/uavs3/uavs3d?scale=0.8&cache=1800)](https://github.com/uavs3/uavs3d)
    - davs2 [![davs2](https://flat.badgen.net/github/last-commit/pkuvcl/davs2?scale=0.8&cache=1800)](https://github.com/pkuvcl/davs2)
    - libsixel [![libsixel](https://flat.badgen.net/github/last-commit/saitoha/libsixel?style=flat-square)](https://github.com/saitoha/libsixel) 
    - libdovi [![libdovi](https://flat.badgen.net/github/last-commit/quietvoid/dovi_tool/main?style=flat-square)](https://github.com/quietvoid/dovi_tool) 
    - libva [![libva](https://flat.badgen.net/github/last-commit/intel/libva?scale=0.8&cache=1800)](https://github.com/intel/libva)
    - libzvbi [![libzvbi](https://flat.badgen.net/github/last-commit/zapping-vbi/zvbi/main?scale=0.8&cache=1800)](https://github.com/zapping-vbi/zvbi)
    - rav1e [![rav1e](https://flat.badgen.net/github/last-commit/xiph/rav1e?scale=0.8&cache=1800)](https://github.com/xiph/rav1e)
    - libaribcaption [![libaribcaption](https://flat.badgen.net/github/last-commit/xqq/libaribcaption?scale=0.8&cache=1800)](https://github.com/xqq/libaribcaption)
    - zlib-ng [![zlib-ng](https://flat.badgen.net/github/last-commit/zlib-ng/zlib-ng?scale=0.8&cache=1800)](https://github.com/zlib-ng/zlib-ng)

- Zip
    - [expat](https://github.com/libexpat/libexpat) (2.5.0) ![](https://img.shields.io/github/v/release/libexpat/libexpat?style=flat-square)
    - [bzip](https://sourceware.org/pub/bzip2/) (1.0.8) ![](https://img.shields.io/github/v/tag/libarchive/bzip2?style=flat-square)
    - [xvidcore](https://labs.xvid.com/source/) (1.3.7)
    - [vorbis](https://xiph.org/downloads/) (1.3.7) ![](https://img.shields.io/github/v/release/xiph/vorbis?style=flat-square)
    - [speex](https://ftp.osuosl.org/pub/xiph/releases/speex/) (1.2.1) ![](https://img.shields.io/github/v/release/xiph/speex?style=flat-square)
    - [ogg](https://ftp.osuosl.org/pub/xiph/releases/ogg/) (1.3.5) ![](https://img.shields.io/github/v/release/xiph/ogg?style=flat-square)
    - [lzo](https://fossies.org/linux/misc/) (2.10)
    - [libopenmpt](https://lib.openmpt.org/libopenmpt/download/) (0.7.2)
    - [libiconv](https://ftp.gnu.org/pub/gnu/libiconv/) (1.17)
    - [gmp](https://gmplib.org/download/gmp/) (6.3.0)
    - [vapoursynth](https://github.com/vapoursynth/vapoursynth) (R63)  ![](https://img.shields.io/github/v/release/vapoursynth/vapoursynth?style=flat-square)
    - [libsdl2](https://www.libsdl.org/release/) (2.28.2)  ![](https://img.shields.io/github/v/release/libsdl-org/SDL?style=flat-square)
    - [mbedtls](https://github.com/Mbed-TLS/mbedtls) (3.4.1) ![](https://img.shields.io/github/v/release/Mbed-TLS/mbedtls?style=flat-square)
    - ~~libressl (3.1.5)~~


### WSL workaround

Place the file on specified location to limit ram & cpu usage to avoid getting stuck while building mpv.

    # /etc/wsl.conf
    [interop]
    #enabled=false
    appendWindowsPath=false

    [automount]
    enabled = true
    options = "metadata"
    mountFsTab = false

    [user]
    default=<user>
    ---------------------------------------
    # C:\Users\<UserName>\.wslconfig
    [wsl2]
    memory=4GB
    swap=0
    pageReporting=false

## Acknowledgements

This project was originally created and maintained [lachs0r](https://github.com/lachs0r/mingw-w64-cmake). Since then, it heavily modified to suit my own need.
