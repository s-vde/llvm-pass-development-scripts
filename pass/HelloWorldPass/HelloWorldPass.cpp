
#include "llvm/IR/Function.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"

namespace
{
    struct HelloWorldPass : public llvm::FunctionPass
    {
        static char ID;
        
        HelloWorldPass() : llvm::FunctionPass(ID)
        {
        }

        bool runOnFunction(llvm::Function &F) override
        {
            ++mFunctionCounter;
            llvm::errs() << "Hello: ";
            llvm::errs().write_escaped(F.getName()) << "\n";
            return false;
        }
        
        unsigned int mFunctionCounter = 0;
        
    }; // end struct HelloWorldPass
} // end namespace

char HelloWorldPass::ID = 0;
static llvm::RegisterPass<HelloWorldPass> X("hello-world", "Hello World Pass");
