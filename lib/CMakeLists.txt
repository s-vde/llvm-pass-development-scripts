cmake_minimum_required(VERSION 3.5)

project(llvm_hello_world)
set(CMAKE_CXX_FLAGS "-install_name @rpath/libHelloWorldLibrary.dylib")
add_library(HelloWorldLibrary SHARED HelloWorldLibrary.cpp)
