cmake_minimum_required(VERSION 3.20)

project(cppfeature LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

add_executable(cppfeature main.cc)

if (MSVC)
    target_compile_options(cppfeature PRIVATE /std:c++latest)
    set(COMPILER_SUPPORTS_CXX23 TRUE)

    if (CMAKE_VERSION VERSION_GREATER 3.12)
        set_property(TARGET cppfeature PROPERTY CXX_STANDARD 23)
    endif()
else ()
    target_compile_options(cppfeature PRIVATE -std=c++23)
endif ()


