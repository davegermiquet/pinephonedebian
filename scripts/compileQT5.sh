#!/bin/bash
echo "
function setup_distcc() {
  echo distcc > /etc/distcc/hosts
  if [ -z \$(find . -maxdepth 1 -name \"configure.ac\") ]; then
    export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
    dpkg-reconfigure distcc
    COMPILERS_TO_REPLACE=\$(ls /usr/lib/distcc/ | grep -v ccache )
    COMPILERS_TO_REPLACE=\"\${COMPILERS_TO_REPLACE} cc c++\"
    for bin in \${COMPILERS_TO_REPLACE}; do
      rm /usr/lib/distcc/\${bin};
    done

      # Create distcc wrapper
    echo '#!/usr/bin/env bash' > /usr/lib/distcc/distccwrapper
    echo 'CCACHE_PREFIX=distcc ccache /usr/bin/aarch64-linux-gnu-g\"\${0:\$[-2]}\" \"\$@\"' >> /usr/lib/distcc/distccwrapper
    chmod +x /usr/lib/distcc/distccwrapper

    # Create distcc wrapper
    for bin in \${COMPILERS_TO_REPLACE}; do
        ln -s /usr/lib/distcc/distccwrapper /usr/lib/distcc/\${bin}
    done

	export DISTCC_HOSTS="192.168.1.183/3 192.168.1.184/3"
    export CCACHE_DIR=/root/.ccache
    export PATH=\"/usr/lib/distcc/:\$PATH\"
  fi
}" > /media/fakeinstallroot/build/addFunction.tmp


mkdir /media/fakeinstallroot/build
rsync -avh /build/* /media/fakeinstallroot/build/

chroot /media/fakeinstallroot /usr/bin/bash -c "source /build/addFunction.tmp;setup_distcc;cd /build/extract/qt5;mkdir qt5-build;cd qt5-build;export QT5PREFIX=/usr; ../configure -confirm-license  -prefix /usr -opensource -nomake examples -nomake tests;which gcc;make -j6 ;  make install"
chroot /media/fakeinstallroot /usr/bin/bash -c "source /build/addFunction.tmp;setup_distcc;cd /build/extract/qt5;mkdir qtwebkit-build;cd qtwebkit-build;export QT5PREFIX=/usr; qmake ../  && make -j6 &&  make install"
