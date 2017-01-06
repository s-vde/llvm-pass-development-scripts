#!/bin/sh

prefix=`echo $1`
version=`echo $2`

here=`pwd .`

llvm_base=${prefix}/llvm-${version}
llvm_src=${llvm_base}/src
llvm_projects_src=${llvm_src}/projects
llvm_build=${llvm_base}/build

# source locations of subprojects
clang_src=${llvm_src}/tools/clang
compiler_rt_src=${llvm_projects_src}/compiler-rt
libcxx_src=${llvm_projects_src}/libcxx
libcxxabi_src=${llvm_projects_src}/libcxxabi

llvm_download_page=http://releases.llvm.org/${version}

echo ===== Building LLVM-${version} in base dir ${llvm_base}

test -d ${llvm_base} || mkdir -p ${llvm_base}
test -d ${llvm_build} || mkdir ${llvm_build}

echo === Checking or downloading releases

downloads=${prefix}/downloads
test -d ${downloads} || (echo dir ${downloads} does not exist && mkdir downloads)

#
# download_and_untar(tar_name, folder, src_destinaton)
#
download_and_untar() {
   tar_name=`echo $1`
   folder=`echo $2`
   src_destination=`echo $3`
   echo  $'\n'Downloading and Untarring ${tar_name} to ${src_destination}
   untarred=${tar_name}-${version}.src
   tar_file=${untarred}.tar.xz
   test -f ${downloads}/${tar_file} || wget ${llvm_download_page}/${tar_file} -P ${downloads}
   test -d ${src_destination} || (tar xf ${downloads}/${tar_file} -C ${folder} && mv ${folder}/${untarred} ${src_destination})
}
#
#
#

download_and_untar llvm ${llvm_base} ${llvm_src}
download_and_untar cfe ${llvm_src}/tools ${clang_src}
download_and_untar compiler-rt ${llvm_projects_src} ${compiler_rt_src}
download_and_untar libcxx ${llvm_projects_src} ${libcxx_src}
download_and_untar libcxxabi ${llvm_projects_src} ${libcxxabi_src}

echo === Making

cd ${llvm_build}
cmake ../src -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_EH=ON -DLLVM_TARGETS_TO_BUILD=all
cmake --build .
#cmake --build . --target install
cd ${here}
