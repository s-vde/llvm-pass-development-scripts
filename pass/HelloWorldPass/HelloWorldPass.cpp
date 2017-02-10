
#include "llvm/IR/Function.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"

namespace
{
    struct HelloWorldPass : public llvm::ModulePass
    {
        static char ID;
        
        HelloWorldPass() : llvm::ModulePass(ID)
        {
        }

        bool runOnModule(llvm::Module& module) override
        {
            using namespace llvm;
            IRBuilder<> builder(module.getContext());
            Type* void_type = Type::getVoidTy(module.getContext());
            Type* char_ptr_type = builder.getInt8PtrTy();
            AttributeSet attributes;
            attributes = attributes.addAttribute(module.getContext(),
                                                 AttributeSet::FunctionIndex,
                                                 Attribute::NoUnwind);
            FunctionType* hello_world_type = FunctionType::get(void_type, { char_ptr_type }, false );
            Function* hello_world_prototype = cast<Function>(module.getOrInsertFunction("hello_world",
                                                                                        hello_world_type,
                                                                                        attributes));
            for (auto& function : module.getFunctionList())
            {
                runOnFunction(function, hello_world_prototype);
            }
            
            return false;
        }
        
        void runOnFunction(llvm::Function& function, llvm::Function* hello_world_prototype)
        {
            using namespace llvm;
            // This check has to be in place in order to prevent hello_world from being instrumented
            if (function.getName().str() != "hello_world")
            {
//                llvm::errs() << "Instrumenting: " << function.getName() << "\n";
                Instruction* before = &function.front().front();
                IRBuilder<> builder(before);
                Value* arg = builder.CreateGlobalStringPtr(function.getName());
                builder.CreateCall(hello_world_prototype, { arg });
                ++mFunctionCounter;
            }
        }
        
        unsigned int mFunctionCounter = 0;
        
    }; // end struct HelloWorldPass
} // end namespace

char HelloWorldPass::ID = 0;
static llvm::RegisterPass<HelloWorldPass> X("hello-world", "Hello World Pass");
