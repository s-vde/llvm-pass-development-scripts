#!/bin/sh

prefix=`echo $1`

here=`pwd .`

llvm_base=${prefix}/llvm-repo
llvm_src=${llvm_base}/src
llvm_projects_src=${llvm_src}/projects
llvm_build=${llvm_base}/build

# source locations of subprojects
clang_src=${llvm_src}/tools/clang
compiler_rt_src=${llvm_projects_src}/compiler-rt
libcxx_src=${llvm_projects_src}/libcxx
libcxxabi_src=${llvm_projects_src}/libcxxabi

llvm_git=http://llvm.org/git

echo ===== Building latest LLVM in base dir ${llvm_base} from ${llvm_git}

test -d ${llvm_base} || mkdir -p ${llvm_base}
test -d ${llvm_build} || mkdir ${llvm_build}

#
# clone_or_update_repository(repo_name, repo_location)
#
clone_or_update_repository() {
   repo_name=`echo $1`
   repo_location=`echo $2`
   echo  $'\n'Cloning or Updating ${repo_name}
   test -d ${repo_location} || git clone ${llvm_git}/${repo_name} ${repo_location}
   cd ${repo_location}
   git pull origin master
   cd ${here}
}
#
#
#

clone_or_update_repository llvm ${llvm_src}
clone_or_update_repository clang ${clang_src}
clone_or_update_repository compiler-rt ${compiler_rt_src}
clone_or_update_repository libcxx ${libcxx_src}
clone_or_update_repository libcxxabi ${libcxxabi_src}

echo === Making

cd ${llvm_build}
cmake ../src -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_EH=ON -DLLVM_TARGETS_TO_BUILD=all
cmake --build .
#cmake --build . --target install
cd ${here}
