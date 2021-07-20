#!/usr/bin/env bash

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

export CFLAGS="-Wall -pipe -O2  -fPIC -I${PREFIX}/include ${CFLAGS}"
if [[ "$target_platform" != "linux-aarch64" ]]; then
  # probably not necessary anywhere, but makes aarch64 unhappy for sure
  export CFLAGS="-m64 ${CFLAGS}"
fi

export CXXFLAGS="${CFLAGS} ${CXXFLAGS}"
export CPPFLAGS="-I${PREFIX}/include ${CPPFLAGS}"
export LDFLAGS="-L${PREFIX}/lib ${LDFLAGS}"
export LFLAGS="-fPIC ${LFLAGS}"
export FC=""

# needed for clang_osx-64
if [ ${HOME} == "/Users/distiller" ]; then
    export CFLAGS="-Wl,-syslibroot / -isysroot / ${CFLAGS}"
    # configure need this otherwise "error.h" is not found and configure report netcdf.h 
    export CPPFLAGS="-Wl,-syslibroot / -isysroot / -I${PREFIX}/include ${CPPFLAGS}"
fi
./configure --prefix=${PREFIX} || (cat config.log && exit 1)
make
make install
if [ `uname` == Linux ]; then
    LDSHARED="$CC -shared -pthread"  ${PYTHON} setup.py install;
else
    # LDSHARED_FLAGS="-bundle -undefined dynamic_lookup"  ${PYTHON} setup.py install;
    ${PYTHON} setup.py install;
fi
