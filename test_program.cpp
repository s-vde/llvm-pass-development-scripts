
int additor(int i)
{
    return ++i;
}

int subtractor(int i)
{
    return --i;
}

int main()
{
    return additor(subtractor(0));
}