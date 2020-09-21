#!/bin/bash

export MAKE="/usr/local/bin/distmake"
export DISTCC_HOSTS="+zeroconf"
export CCACHE_PREFIX="distcc"
export DISTCC_JOBS=`distcc -j`
export CC="ccache gcc"
export CXX="ccache g++"

echo "Building with $DISTCC_JOBS parallel jobs on following servers:"
for server in `distcc --show-hosts`; do
                server=$(echo $server | sed 's/:.*//')
                echo -e "\t$server"
done

BCMD="debuild -rfakeroot"
EXTRA_FLAGS="-eCC -eCXX -eCCACHE_PREFIX -eMAKE -eDISTCC_HOSTS -eDISTCC_JOBS"
if [ -d .svn ]; then
                BCMD="svn-buildpackage --svn-builder $BCMD"
fi
echo $BCMD $EXTRA_FLAGS $@
$BCMD $EXTRA_FLAGS $@