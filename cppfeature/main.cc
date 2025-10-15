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



struct A {
    int x;
    double y;
};

struct B {
    std::string name;
    A a;
};

B b{"example", {10, 20.5}};

void test_property()
{
    Property prop;

    // 设置属性
    prop.set("username", "JohnDoe");
    prop.set("age", 30);
    prop.set("active", true);
    prop.set("height", 175.5f);
    prop.set("B", b);

    // 获取属性
    std::cout << "Username: " << prop.get<std::string>("username").value() << std::endl;
    std::cout << "Age: " << *prop.get<int>("age") << std::endl;
    std::cout << std::format("Height: {:.2f} cm\n", prop.get<float>("height").value());
    if (auto retrieved = prop.get<B>("B"); retrieved.has_value()) {
        std::cout << std::format("Custom Type B: name={}, a.x={}, a.y={}\n",
                                 retrieved->name, retrieved->a.x, retrieved->a.y);
    }
    
    // 检查属性存在性
    if (const auto active = prop.get<bool>("active"); active.has_value())
    {
        std::cout << "Account status: " << (active.value() ? "Active" : "Inactive") << std::endl;
    }

    // 删除属性
    prop.remove("height");
    if (!prop.has("height"))
    {
        std::cout << "Height property removed\n";
    }

    // 处理不存在属性
    if (const auto invalid = prop.get<double>("invalid_key"); !invalid.has_value())
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

    // 自定义类型测试
    v = b;
    if (auto retrieved = v.get<B>(); retrieved.has_value()) {
        std::cout << std::format("自定义类型B: name={}, a.x={}, a.y={}\n",
                                 retrieved->name, retrieved->a.x, retrieved->a.y);
    }

    // 清空操作
    v.clear();
    std::cout << "清空后是否有效? " << (v.isValid() ? "是" : "否") << std::endl;
}

int main(int argc, const char *argv[]) {
    test_property();
    test_variant();
    return 0;
}