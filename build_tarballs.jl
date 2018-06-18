# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build TestU01
sources = [
    "http://simul.iro.umontreal.ca/testu01/TestU01.zip" =>
    "bc1d1dd2aea7ed3b3d28eaad2c8ee55913f11ce67aec8fe4f643c1c0d2ed1cac",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd TestU01-1.2.3/
update_configure_scripts
if [ $target = "x86_64-w64-mingw32" ]; then
  lt_cv_deplibs_check_method=pass_all ./configure --prefix=$prefix --host=$target LDFLAGS="-L/opt/x86_64-w64-mingw32/x86_64-w64-mingw32/lib/ -lws2_32"
else
  ./configure --prefix=$prefix --host=$target
fi
make tcode.o EXEEXT="" CC=/opt/x86_64-linux-gnu/bin/gcc
make tcode EXEEXT="" CC=/opt/x86_64-linux-gnu/bin/gcc LDFLAGS="" CFLAGS=""
make EXEEXT=""
make install EXEEXT=""

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf),
    MacOS(:x86_64),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libtestu01", :libtestu01)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "TestU01", sources, script, platforms, products, dependencies)
