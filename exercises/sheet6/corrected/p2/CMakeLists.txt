cmake_minimum_required(VERSION 3.6)
project(cpp_test)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES main.cpp include.cpp)
add_executable(cpp_test ${SOURCE_FILES})