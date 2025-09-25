#pragma once

#include <any>
#include <optional>
#include <string>


namespace LIVIO
{
class Variant final
{
public:
    Variant(const char *str) : value_(std::string(str)) // NOLINT(*-explicit-constructor)
    {
    }

    template<typename T>
    Variant(T &&value) : value_(std::forward<T>(value)) // NOLINT(*-explicit-constructor)
    {
    }

    template<typename T>
    Variant &operator=(T &&value)
    {
        value_ = std::forward<T>(value);
        return *this;
    }

    Variant &operator=(const char *str)
    {
        value_ = std::string{str};
        return *this;
    }

    template<typename T>
    std::optional<T> get() const
    {
        if (auto v = std::any_cast<T>(&value_))
            return *v;
        return std::nullopt;
    }

    template<typename T>
    [[nodiscard]] bool is() const
    {
        return value_.type() == typeid(T);
    }

    void clear()
    {
        value_.reset();
    }

    [[nodiscard]] bool isNull() const
    {
        return !value_.has_value();
    }

    [[nodiscard]] bool isValid() const
    {
        return value_.has_value();
    }

    [[nodiscard]] std::string typeName() const
    {
        return value_.has_value() ? value_.type().name() : "undefined";
    }

private:
    std::any value_;
};
} // namespace LIVIO
