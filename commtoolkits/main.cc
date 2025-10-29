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
#include "Property.h"

using namespace LIVIO;

void test_property()
{
    Property prop;

    // 设置属性
    prop.setProperty("username", "JohnDoe");
    prop.setProperty("age", 30);
    prop.setProperty("active", true);
    prop.setProperty("height", 175.5f);

    // 获取属性
    std::cout << "Username: " << prop.getProperty<std::string>("username").value() << std::endl;
    std::cout << "Age: " << *prop.getProperty<int>("age") << std::endl;

    // 检查属性存在性
    if (const auto active = prop.getProperty<bool>("active"); active.has_value())
    {
        std::cout << "Account status: " << (active.value() ? "Active" : "Inactive") << std::endl;
    }

    // 删除属性
    prop.removeProperty("height");
    if (!prop.hasProperty("height"))
    {
        std::cout << "Height property removed\n";
    }

    // 处理不存在属性
    if (const auto invalid = prop.getProperty<double>("invalid_key"); !invalid.has_value())
    {
        std::cout << "Invalid key not found\n";
    }
}


int main(int argc, const char *argv[])
{
    test_property();
    return 0;
}