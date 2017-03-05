
source activate "${CONDA_DEFAULT_ENV}"

export CFLAGS="-Wall -m64 -pipe -O2 -fPIC ${CFLAGS}"
export CXXFLAGS="${CFLAGS} ${CXXFLAGS}"
export CPPFLAGS="-I${PREFIX}/include ${CPPFLAGS}"
export LDFLAGS="-L${PREFIX}/lib ${LDFLAGS}"
export LFLAGS="-fPIC ${LFLAGS}"

# try this to see if it
#
if "darwin" in platform.system().lower():
    dep_tgt = platform.mac_ver()[0]
    dep_tgt = dep_tgt[:dep_tgt.rfind(".")]
    print "[setting MACOSX_DEPLOYMENT_TARGET to %s]" % dep_tgt
    env["MACOSX_DEPLOYMENT_TARGET"] = dep_tgt


./configure --prefix=${PREFIX}

${PYTHON} setup.py install

if [ `uname` == Darwin ]; then install_name_tool -change /System/Library/Frameworks/Python.framework/Versions/2.7/Python @rpath/libpython2.7.dylib ${SP_DIR}/pycf/*.so ; fi
