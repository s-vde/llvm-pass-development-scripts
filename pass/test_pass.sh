
#!/bin/sh

llvm_base=`echo $1`
program=`echo $2`
llvm_bin=${llvm_base}/build/bin

here=`pwd .`

cd build
cmake ../ -DLLVM_DIR=${llvm_base}/build/lib/cmake/llvm
make
cd ${here}

${llvm_bin}/clang++ -pthread -emit-llvm -c ${program} -o ${program}.bc;
${llvm_bin}/opt -S -load build/HelloWorldPass/LLVMHelloWorldPass.dylib -hello-world < ${program}.bc > ${program}.instrumented.bc
