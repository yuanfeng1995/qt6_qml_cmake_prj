#pragma once

#include <string_view>
#include <unordered_map>
#include "Variant.h"

namespace LIVIO
{
class Property
{
public:
    void set(std::string name, Variant &&value)
    {
        properties_.insert_or_assign(std::move(name), std::move(value));
    }

    template<typename T>
    std::optional<T> get(std::string_view name) const
    {
        if (const auto key = std::string{name}; properties_.contains(key))
        {
            return properties_.at(key).get<T>();
        }
        return std::nullopt;
    }

    void remove(std::string_view name)
    {
        const auto key = std::string{name};
        properties_.erase(key);
    }

    [[nodiscard]] bool has(std::string_view name) const
    {
        const auto key = std::string{name};
        return properties_.contains(key);
    }

private:
    std::unordered_map<std::string, Variant> properties_;
};
} // namespace LIVIO
