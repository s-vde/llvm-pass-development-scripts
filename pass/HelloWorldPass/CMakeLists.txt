
add_llvm_loadable_module(LLVMHelloWorldPass
	HelloWorldPass.cpp
PLUGIN_TOOL
  	opt
)

# Find the libraries that correspond to the LLVM components
# that we wish to use
llvm_map_components_to_libnames(llvm_libs all)

# Link against LLVM libraries
target_link_libraries(LLVMHelloWorldPass ${llvm_libs})
