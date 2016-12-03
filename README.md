# CMake-based MinGW-w64 Cross Toolchain

This thing’s primary use is to build Windows binaries of mpv.

Alternatively, you can download the builds from [here](https://sourceforge.net/projects/mpv-player-windows/files/).

## Prerequisites

In addition to CMake, you need the usual development stuff (Git, Subversion,
GCC, Binutils, ragel, headers for GMP, MPFR and MPC).

 -  You should also install Ninja and use CMake’s Ninja build file generator.
    It’s not only much faster than GNU Make, but also far less error-prone,
    which is important for this project because CMake’s ExternalProject module
    tends to generate makefiles which confuse GNU Make’s jobserver thingy.

 -  As a build environment, any modern Linux distribution *should* work,
    however I am only testing this on openSUSE, which (as of November 2014)
    is using a 4.8 series GCC by default. Feel free to contribute fixes for
    other environments.

-   You cannot use this cmake script on **MSYS2** due to various problems.


## Information about packages

- Git/Hg
    - ANGLE
    - FFmpeg
    - xz
    - x264
    - x265 (multilib)
    - uchardet
    - rubberband
    - opus
    - openal-soft
    - mpv
    - luajit
    - libvpx
    - libpng
    - libsoxr
    - libzimg
    - libdvdread
    - libdvdnav
    - libdvdcss
    - libbluray
    - libass
    - lcms2
    - lame
    - harfbuzz
    - game-music-emu
    - freetype2
    - flac
    - opus-tools
    - vapoursynth

- Zip
    - expat (2.2.0)
    - bzip (1.0.6)
    - zlib (1.2.8)
    - xvidcore (1.3.4)
    - vorbis (1.3.5)
    - speex (1.2rc2)
    - ogg (1.3.2)
    - lzo (2.09)
    - libmodplug (0.8.8.5)
    - libjpeg (1.5.0)
    - libiconv (1.14)
    - libarchive (3.2.1)
    - gmp (6.1.1)
    - fribidi (0.19.7)


## Prerequisites for Manjaro / Arch Linux

These packages need to be installed first before compiling mpv:

    pacman -S git ninja cmake ragel yasm asciidoc enca gperf p7zip gcc-multilib

For building pdf, these packages are needed:

    pacman -S python2-pip python-docutils python2-rst2pdf python2-lxml python2-pillow

* gyp is needed to build ANGLE.

## Prerequisites for Ubuntu Linux / WSL (Windows 10)

    apt-get install build-essential checkinstall bison flex gettext git mercurial subversion ninja-build gyp cmake yasm automake pkg-config libtool libtool-bin gcc-multilib g++-multilib libgmp-dev libmpfr-dev libmpc-dev libgcrypt-dev gperf ragel texinfo autopoint re2c asciidoc python-docutils rst2pdf docbook2x

**Note:**

* Works for Ubuntu 15.10 and later. Ubuntu 14.04 used outdated packages which make compilation failed. For WSL, upgrade with [this](https://github.com/Microsoft/BashOnWindows/issues/482#issuecomment-230551101) [step](https://github.com/Microsoft/BashOnWindows/issues/482#issuecomment-234695431)
* Use [apt-fast](https://github.com/ilikenwf/apt-fast) if apt-get is too slow.
* It is advised to use bash over dash. Set `sudo ln -sf /bin/bash /bin/sh`. Revert back by `sudo ln -sf /bin/dash /bin/sh`.
* For WSL, some packages will fail when compiling to 32bit. This is because WSL [doesn't support multilib ABI](https://github.com/Microsoft/BashOnWindows/issues/711/) yet.


## Parallel Build

By default, this script set MAKEJOBS value based on total number of cpu (+HyperThreading). If your compilation always failed for unknown reason,
consider manually set MAKEJOBS value in the `CMakeLists` file. Basic rule is 1 core + 1.
If you have 4-core cpu, the MAKEJOBS value should be 5.


## Building Software

To set up the build environment, create a directory to store build files in::

    mkdir build-64
    cd build-64

Once you’ve changed into that directory, run CMake, e.g.

    cmake -DTARGET_ARCH=x86_64-w64-mingw32 -G Ninja ..

or for 32bit:

    cmake -DTARGET_ARCH=i686-w64-mingw32 -G Ninja ..

First, you need to build toolchain. By default, it will be installed in `install` folder. This take ~20 minutes on my 4-core machine.

    ninja gcc

After it done, you're ready to build mpv and all its dependencies:

    ninja mpv

This will take a while (about ~10 minutes on my machine).



### Unpackaged Stuff

Using the toolchain to build stuff which doesn’t have a package is usually
very easy. There are two generated files in your build directory to help with
this: “exec” and “toolchain.cmake”.

For most software (i.e. almost everything that uses GNU Autotools), you can
use “exec” with the configure command:

    ~/mingw/build-64/exec ./configure --prefix=~/mingw/prefix-64/mingw --host=x86_64-w64-mingw32

An alternative is to run “source ~/mingw/build-64/exec” to set all the required
environment variables in your current session.

For software that uses CMake, you can use “toolchain.cmake” like this:

    cmake -DCMAKE_TOOLCHAIN_FILE=~/mingw/build-64/toolchain.cmake -DCMAKE_INSTALL_PREFIX=~/mingw/prefix-64/mingw

In general, it is advisable to use static linking when building for Windows.
To do that, use --disable-shared and/or --enable-static with Autotools-based
configure scripts.

CMake doesn’t have a standard way to achieve this, so you’re on your own.

-   It’s usually easy to make CMake projects link statically if they don’t have
    an option for it already. If you need an example, look at the patches for
    ``game-music-emu``.


### Creating Packages

To add a new package, create a new ``.cmake`` file in the ``packages``
directory (just look at how the existing packages work) and add it to the
list in ``packages/CMakeLists.txt`` (they must appear after their
dependencies).

See the CMake documentation on the ExternalProject module for further info.
