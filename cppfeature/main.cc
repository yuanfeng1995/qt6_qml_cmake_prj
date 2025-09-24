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

void test_variant()
{
    Variant v;

    // 整型测试
    v = 42;
    std::cout << "INT: " << v.get<int>().value() << std::endl;


    // 浮点数测试
    v = 3.14;
    std::cout << "FLOAT: " << std::fixed << v.get<double>().value() << std::endl;

    // 字符串测试
    v = std::string("hello variant");
    std::cout << "STRING: " << v.get<std::string>().value() << std::endl;

    // 类型检查演示
    std::cout << "IS DOUBLE: " << (v.is<double>() ? "yes" : "no") << std::endl;

    // 清空操作
    v.clear();
    std::cout << "IS VALID: " << (v.isValid() ? "yes" : "no") << std::endl;
}


void test_property()
{
    Property prop;

    // 设置属性
    prop.setProperty("username", "JohnDoe");
    prop.setProperty("age", 30);
    prop.setProperty("active", true);
    prop.setProperty("height", 175.5f);

    // 获取属性
    auto username = prop.getProperty<std::string>("username").value();
    std::cout << "Username: " << username << std::endl;
    auto age = prop.getProperty<int>("age").value();
    std::cout << "Age: " << age << std::endl;

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
    // test_variant();
    test_property();
    return 0;
}
