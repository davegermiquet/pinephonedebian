#!/bin/bash
make --jobs=${DISTCC_JOBS:-1} "$@"

