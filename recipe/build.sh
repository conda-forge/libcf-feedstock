export CFLAGS="${CFLAGS} -Wall -m64 -pipe -O2  -fPIC -I${PREFIX}/include"
export CXXFLAGS="${CFLAGS} ${CXXFLAGS}"
export CPPFLAGS="-I${PREFIX}/include ${CPPFLAGS}"
export LDFLAGS="-L${PREFIX}/lib -L.lib -Llib${LDFLAGS}"
export LFLAGS="-fPIC  ${LDFALGS} ${LFLAGS}"
export FC=""

# needed for clang_osx-64
if [ `uname` == Darwin ]; then
    export CFLAGS="-Wl,-syslibroot / -isysroot / ${CFLAGS}"
    # configure need this otherwise "error.h" is not found and configure report netcdf.h 
    export CPPFLAGS="-Wl,-syslibroot / -isysroot / -I${PREFIX}/include ${CPPFLAGS}"
fi
./configure --prefix=${PREFIX}
make
make install
if [ `uname` == Linux ]; then
    LDSHARED="$CC -shared -pthread"  ${PYTHON} setup.py install;
else
    # LDSHARED_FLAGS="-bundle -undefined dynamic_lookup"  ${PYTHON} setup.py install;
    ${PYTHON} setup.py install;
fi
# if [ `uname` == Darwin ]; then install_name_tool -change /System/Library/Frameworks/Python.framework/Versions/2.7/Python @rpath/libpython2.7.dylib ${SP_DIR}/pycf/*.so ; fi
