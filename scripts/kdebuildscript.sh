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


    export CCACHE_DIR=/root/.ccache
    export PATH=\"/usr/lib/distcc/:\$PATH\"
  fi
}" > /media/fakeinstallroot/build/addFunction.tmp


  chroot /media/fakeinstallroot /usr/bin/bash -c "source /build/addFunction.tmp;setup_distcc;which gcc;cd /build/extra-cmake-modules;mkdir build && cd build;cmake -DCMAKE_PREFIX_PATH=/usr -DCMAKE_INSTALL_PREFIX=/usr .. && make &&  make install"
chroot /media/fakeinstallroot /usr/bin/bash -c "source /build/addFunction.tmp;setup_distcc;which gcc;/build/kdesrc-build/kdesrc-build --initial-setup"
/bin/sed 's/\~\/kde\/usr/\/usr/g' /media/fakeinstallroot/root/.kdesrc-buildrc > /tmp/.kdesrc-buildrc
rm /media/fakeinstallroot/root/.kdesrc-buildrc
cp /tmp/.kdesrc-buildrc /media/fakeinstallroot/root/.kdesrc-buildrc
/bin/sed 's/\#   qtdir  \~\/kde\/qt5 \# Where to install Qt5 if kdesrc-build supplies it/qtdir \/usr/g' /media/fakeinstallroot/root/.kdesrc-buildrc  > /tmp/.kdesrc-buildrc
rm /media/fakeinstallroot/root/.kdesrc-buildrc
cp /tmp/.kdesrc-buildrc /media/fakeinstallroot/root/.kdesrc-buildrc
grep "^include /build/qt5" /media/fakeinstallroot/root/.kdesrc-buildrc || echo "include /build/qt5" >> /media/fakeinstallroot/root/.kdesrc-buildrc
chroot /media/fakeinstallroot /usr/bin/bash -c "source /build/addFunction.tmp;setup_distcc;which gcc;/build/kdesrc-build/kdesrc-build kdesrc-build kdeplasma-addons plasma-workspace plasma-framework plasma-settings kdbusaddons &&  touch /build/kdebuildscriptdone.txt"