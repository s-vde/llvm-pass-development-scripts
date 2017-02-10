
#include <vector>

std::vector<int>& additor(std::vector<int>& vec)
{
    for (auto& element : vec)
    {
        ++element;
    }
    return vec;
}

std::vector<int>& subtractor(std::vector<int>& vec)
{
    for (auto& element : vec)
    {
        --element;
    }
    return vec;
}

int main()
{
    std::vector<int> vec(5, 0);
    additor(subtractor(vec));
    
    return std::all_of(vec.begin(), vec.end(), [] (const auto& element) { return element == 0; });
}
