#!/bin/sh


if [ ! -f ".cmake_last_build" ]; then
  echo ERROR: run cmake first!
  exit 1
fi

build_type=`cat ".cmake_last_build"`
echo Start build. Configuration: $build_type
cd build/$build_type && make
