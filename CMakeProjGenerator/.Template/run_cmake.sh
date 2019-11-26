#!/bin/sh

build_type=Release
build_tests=OFF
build_run_make=0
WORK_DIR=$PWD

for param in $*; do
  name=${param%%=*}
  value=${param#*=}
  case "$name" in
    --type) build_type=$value;;
    --tests) build_tests=$value;;
    --run_make) build_run_make=1;;
  esac
done

create_dirs() {
  for dir in build output; do
    if [ ! -d $dir ]; then
      mkdir $dir
    fi
    if [ ! -d $dir/$build_type ]; then
      mkdir $dir/$build_type
    fi
  done
}

create_dirs
for dir in $PWD/build/$build_type $PWD/output/$build_type; do
  rm -r $dir/* 2> /dev/null
done
cd build/$build_type
cmake  -DCMAKE_BUILD_TYPE="$build_type"  -DBUILD_GTESTS="$build_tests" ../../src
echo $build_type > $WORK_DIR/.cmake_last_build
if [ $build_run_make -eq 1 ]; then
  make
fi
