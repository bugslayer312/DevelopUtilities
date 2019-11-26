#!/bin/sh

TEMPLATE_DIR=/home/eugene/Projects/.Template

RED_BOLD=`tput setaf 1; tput bold`
GREEN=`tput setaf 2`
RESET=`tput sgr0`
BLUE=`tput setaf 4`
CYAN_BOLD=`tput setaf 6; tput bold`

success() {
    echo "${CYAN_BOLD}Done.${RESET}"
}

fail() {
    echo "${RED_BOLD}Failed!${RESET}"
    return 1
}

step() {
    echo "${BLUE}$@${RESET}"
}

create_folder() {
  if [ ! -d "$*" ]; then
    mkdir "$*" && success || fail
  fi
}

copy_file() {
  cp -f "$TEMPLATE_DIR" "$PWD/" && success || fail
}

PROJECT_NAME=${PWD##*/}

if [ $PROJECT_NAME = "" ]; then
    echo "${RED_BOLD}FAILED: Empty project name!${RESET}"
    exit 1
fi

PROJECT_PATH="$PWD"
SRC_PATH="$PWD/src"
VSCODE_PATH="$PWD/.vscode"
TEMP_PATH="$PWD/tmp"

step "Creating project '$PROJECT_NAME' structure"
for file in `ls -a`; do
  if [ $file != "." ] && [ $file != ".." ] && [ $file != ".git" ] && [ $file != "README.md" ]; then
    rm -rf $file
  fi
done

for dir in "$SRC_PATH" "$VSCODE_PATH"; do
  echo "-- $dir/" && mkdir "$dir" || fail
  if [ $? != 0 ]; then exit 1; fi
done
for file in run_cmake.sh build.sh .gitignore; do
  echo "-- $PWD/$file" && cp -f "$TEMPLATE_DIR/$file" "$PWD/$file" || fail
  if [ $? != 0 ]; then exit 1; fi
done
success

trap 'rm -rf "$TEMP_PATH"' INT
step "Generating project files" && (mkdir "$TEMP_PATH" && cd "$TEMP_PATH" &&
	cmake -DPR_NAME=$PROJECT_NAME -DGEN_OUT_DIR="$PROJECT_PATH" $TEMPLATE_DIR) && success || fail
res=$?
rm -rf "$TEMP_PATH"
trap INT
if [ $res != 0 ]; then exit 1; fi

step "Trying build" && $PWD/run_cmake.sh "--type=Debug --run_make" && success || fail
if [ $? != 0 ]; then exit 1; fi

BINARY_PATH="$PWD/output/Debug/bin/$PROJECT_NAME"
step "Trying run binary '$BINARY_PATH'" && test -f "$BINARY_PATH" && "$BINARY_PATH" && success || fail
