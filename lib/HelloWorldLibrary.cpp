
#include "HelloWorldLibrary.hpp"

#include <vector>

std::vector<std::string> greeted;

void hello_world(const char* function)
{
    std::cout << std::string(function) << " says: Hello, World!\n";
    greeted.push_back(function);
}
