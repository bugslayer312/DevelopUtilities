cmake_minimum_required(VERSION 3.10.0)

project(Generator "NONE")

message("-- Generating file ${GEN_OUT_DIR}/src/CMakeLists.txt")
configure_file(CMakeLists.txt.in ${GEN_OUT_DIR}/src/CMakeLists.txt @ONLY)

message("-- Generating file ${GEN_OUT_DIR}/src/main.cpp")
configure_file(main.cpp.in ${GEN_OUT_DIR}/src/main.cpp @ONLY)

message("-- Generating file ${GEN_OUT_DIR}/.vscode/tasks.json")
configure_file(tasks.json.in ${GEN_OUT_DIR}/.vscode/tasks.json @ONLY)

message("-- Generating file ${GEN_OUT_DIR}/.vscode/launch.json")
configure_file(launch.json.in ${GEN_OUT_DIR}/.vscode/launch.json @ONLY)
