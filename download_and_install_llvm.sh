#!/bin/sh

prefix=`echo $1`
version=`echo $2`

here=`pwd .`

llvm_base=${prefix}/llvm-${version}
llvm_src=${llvm_base}/src
llvm_build=${llvm_base}/build
clang_src=${llvm_src}/tools/clang
libcxx_src=${llvm_src}/projects/libcxx
libcxxabi_src=${llvm_src}/projects/libcxxabi

llvm_download_page=http://releases.llvm.org/${version}

echo ===== Building LLVM-${version} in base dir ${llvm_base} for target ${target}

echo === Checking files

downloads=${prefix}/downloads
test -d ${downloads} || (echo dir ${downloads} does not exist && mkdir downloads)

# llvm
llvm_tar=llvm-${version}.src.tar.xz
test -f ${downloads}/${llvm_tar} || wget ${llvm_download_page}/${llvm_tar} -P ${downloads}

# clang
clang_tar=cfe-${version}.src.tar.xz
test -f ${downloads}/${clang_tar} || wget ${llvm_download_page}/${clang_tar} -P ${downloads}

# libc++
libcxx_tar=libcxx-${version}.src.tar.xz
test -f ${downloads}/${libcxx_tar} || wget ${llvm_download_page}/${libcxx_tar} -P ${downloads}

# libc++abi
libcxxabi_tar=libcxxabi-${version}.src.tar.xz
test -f ${downloads}/${libcxxabi_tar} || wget ${llvm_download_page}/${libcxxabi_tar} -P ${downloads}

echo === Setup project dirs

test -d ${llvm_base} || (echo Creating dir ${llvm_base} && mkdir -p ${llvm_base})
test -d ${llvm_src} || (echo Untarring llvm sources to ${llvm_src} && tar xf ${downloads}/${llvm_tar} -C ${llvm_base} && mv ${llvm_base}/llvm-${version}.src ${llvm_src})
test -d ${clang_src} || (echo Untarring clang sources to ${clang_src} && tar xf ${downloads}/${clang_tar} -C ${llvm_src}/tools && mv ${llvm_src}/tools/cfe-${version}.src ${clang_src})
test -d ${libcxx_src} || (echo Untarring libcxx sources to ${libcxx_src} && tar xf ${downloads}/${libcxx_tar} -C ${llvm_src}/projects && mv ${llvm_src}/projects/libcxx-${version}.src ${libcxx_src})
test -d ${libcxxabi_src} || (echo Untarring libcxxabi sources to ${libcxxabi_src} && tar xf ${downloads}/${libcxxabi_tar} -C ${llvm_src}/projects && mv ${llvm_src}/projects/libcxxabi-${version}.src ${libcxxabi_src})
test -d ${llvm_build} || (echo Creating dir ${llvm_build} && mkdir ${llvm_build})

echo === Making

cd ${llvm_build}
cmake ../src -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_EH=ON -DLLVM_TARGETS_TO_BUILD=all
cmake --build .
cmake --build . --target install
cd ${here}

