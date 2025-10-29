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


if (WITH_UNIT_TESTS)
    find_package(Catch2 REQUIRED)

    enable_testing()
    include(CTest)
    include(Catch)
    # 自动扫描 tests/ 下的所有 .cpp 文件
    file(GLOB TEST_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/tests/*.cc")

    # 循环为每个测试源文件生成一个可执行文件
    foreach(test_src ${TEST_SOURCES})
        # 提取文件名（不带扩展名），作为 target 名
        get_filename_component(test_name ${test_src} NAME_WE)

        add_executable(${test_name} ${test_src})
        
        target_link_libraries(${test_name} PRIVATE Catch2::Catch2WithMain)

        # 注册到 CTest
        catch_discover_tests(${test_name})
    endforeach()
 
endif()