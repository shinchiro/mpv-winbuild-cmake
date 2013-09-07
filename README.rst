CMake-based MinGW-w64 Cross Toolchain
=====================================

This thing’s primary use is to build Windows binaries of mpv.

Prerequisites
-------------

.. warning::
    As a general rule, make sure your stuff is *recent*. I don’t want to hear
    any complaints about stuff not building on outdated systems.

In addition to CMake, you need the usual development stuff (Git, Subversion,
GCC, Binutils, headers for GMP, MPFR and MPC) as well as some things required
by the packages you want to build, like glib-genmarshal for glib, gtkdocize for
harfbuzz, and probably others.

.. note::
    You should also install Ninja and use CMake’s Ninja build file generator.
    It’s not only much faster than GNU Make, but also far less error-prone,
    which is important for this project because CMake’s ExternalProject module
    tends to generate makefiles which confuse GNU Make’s jobserver thingy.


Building Software
-----------------

To set up the build environment, create a directory to store build files in::

    mkdir build-64
    cd build-64

Once you’ve changed into that directory, run CMake, e.g.::

    cmake -DTARGET_ARCH=x86_64-w64-mingw32 -DCMAKE_INSTALL_PREFIX=../prefix-64 -DMAKEJOBS=2 -G Ninja ..

Once that’s done, you’re ready to build stuff. For example, to build mpv and
all of its dependencies::

    ninja mpv

This will take a while (about 20 minutes on my machine).

.. note::
    The mpv package has some additional steps to generate a 7zip archive ready
    for distribution instead of installing it to the prefix.


Unpackaged Stuff
~~~~~~~~~~~~~~~~

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

.. note::
    It’s usually easy to make CMake projects link statically if they don’t have
    an option for it already. If you need an example, look at the patches for
    ``game-music-emu``.


Creating Packages
~~~~~~~~~~~~~~~~~

To add a new package, create a new ``.cmake`` file in the ``packages``
directory (just look at how the existing packages work) and add it to the
list in ``packages/CMakeLists.txt`` (they must appear after their
dependencies).

See the CMake documentation on the ExternalProject module for further info.
