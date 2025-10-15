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

void test_variant() {
    LIVIO::Variant v;

    // 整型测试
    v = 42;
    std::cout << "整型值: " << v.get<int>().value() << std::endl;

    // 浮点数测试
    v = 3.14;
    std::cout << "浮点值: " << std::fixed << v.get<double>().value() << std::endl;

    // 字符串测试
    v = std::string("hello variant");
    std::cout << "字符串值: " << v.get<std::string>().value() << std::endl;

    // 类型检查演示
    std::cout << "是否是double类型? " << (v.is<double>() ? "是" : "否") << std::endl;

    // 清空操作
    v.clear();
    std::cout << "清空后是否有效? " << (v.isValid() ? "是" : "否") << std::endl;
}

int main(int argc, const char *argv[]) {
    test_property();
    test_variant();
    return 0;
}