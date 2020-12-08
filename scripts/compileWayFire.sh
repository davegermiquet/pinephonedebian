#!/bin/bash
echo "
function setup_distcc() {
  echo \"192.168.1.183/4 192.168.1.184/4\" > /etc/distcc/hosts
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
    echo 'CCACHE_PREFIX=distcc /usr/bin/aarch64-linux-gnu-g\"\${0:\$[-2]}\" \"\$@\"' >> /usr/lib/distcc/distccwrapper
    chmod +x /usr/lib/distcc/distccwrapper

    # Create distcc wrapper
    for bin in \${COMPILERS_TO_REPLACE}; do
        ln -s /usr/lib/distcc/distccwrapper /usr/lib/distcc/\${bin}
    done
    export DISTCC_HOSTS=\"192.168.1.183/4 192.168.1.184/4\"
    export CCACHE_DIR=/root/.ccache
    export PATH=\"/usr/lib/distcc/:\$PATH\"
  fi
}" > /media/fakeinstallroot/build/addFunction.tmp

chroot /media/fakeinstallroot /usr/bin/bash -c "source /build/addFunction.tmp;setup_distcc;cd /build/extract/wayfire;export CC=/usr/lib/distcc/gcc;export CXX=/usr/lib/distcc/g++; meson build;ninja -C build;ninja -C build install"
