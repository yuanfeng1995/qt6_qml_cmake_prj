/**
 * @file main.cc
 * @author livio (yuanfeng1897@outlook.com)
 * @description:
 * @date 2025-09-10 
 *
 * @copyright Copyright (c) 2025
 *
 */

#include <format>
#include <iostream>
#include <span>
 
auto testSpan(std::span<int> _p)
{
    for (auto &&i: _p)
    {
        i = 0;
    }
}

int main(int argc, const char *argv[])
{
    int arr[] = {13, 4};
    testSpan(arr);
    std::println(std::cout, "{},{}", arr[0], arr[1]);
    return 0;
}
