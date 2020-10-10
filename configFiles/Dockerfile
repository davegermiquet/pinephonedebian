FROM amd64/debian:unstable
ARG PACKAGES="distcc crossbuild-essential-arm64 build-essential libc6-dev-arm64-cross gcc g++ git gcc-*-aarch64-linux-gnu g++-*-aarch64-linux-gnu libncurses5-dev ccache procps distcc-pump cmake cmake-data"
ARG ARCH="aarch64-linux-gnu"
RUN dpkg --add-architecture aarch64
# ENV OPTIONS --allow 1.1.1.1 --allow 2.2.2.2

# Prerequisites for adding the repositories
# Remove the apt cache to keep layer-size small.
#!/usr/bin/env bash

RUN apt-get update -y && apt-get upgrade -y && apt-get install ${PACKAGES} -y

RUN bash -c 'echo -n "Removing existing distcc symlinks... " && \
	rm -f /usr/lib/distcc/${ARCH}-gcc ; \
    rm -f /usr/lib/distcc/${ARCH}-g++ ;\
    rm -f /usr/lib/distcc/cc  ; \
    rm -f s/usr/lib/distcc/c++; \
	echo -n "Creating new symlinks for ${ARCH}..." && \
	ln -s /usr/bin/distcc /usr/lib/distcc/${ARCH}-gcc && \
	ln -s /usr/bin/distcc /usr/lib/distcc/${ARCH}-g++ &&\
    ln -s /usr/bin/distcc /usr/lib/distcc/cc  && \
    ln -s /usr/bin/distcc /usr/lib/distcc/c++'
# This is the operations port
EXPOSE 3632
# This is the statistics port
EXPOSE 3633
EXPOSE 3636
RUN touch /var/log/distcd.log
RUN chown distccd /var/log/distcd.log
USER distccd
ENTRYPOINT /usr/bin/distccd --no-detach --log-level debug --log-file=/var/log/distcd.log  --daemon $OPTIONS
