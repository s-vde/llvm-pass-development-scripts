
#!/bin/sh

llvm_base=`echo $1`
program=`echo $2`
llvm_bin=${llvm_base}/build/bin

here=`pwd .`

#cd build
#cmake ../ -DLLVM_DIR=${llvm_base}/build/lib/cmake/llvm
#make
#cd ${here}

test -d lib/build || mkdir -p lib/build
cd lib/build
cmake ../
make
cd ${here}

test -d pass/build || mkdir -p pass/build
cd pass/build
cmake ../ -DLLVM_DIR=${llvm_base}/build/lib/cmake/llvm
make
cd ${here}

${llvm_bin}/clang++ -pthread -emit-llvm -Ilib/ -c ${program} -o ${program}.bc;
${llvm_bin}/opt -S -load pass/build/HelloWorldPass/LLVMHelloWorldPass.dylib -hello-world < ${program}.bc > ${program}.instrumented.bc
${llvm_bin}/clang++ ${program}.instrumented.bc lib/build/libHelloWorldLibrary.dylib -o ${program}.linked -rpath ./lib/build/
./${program}.linked
