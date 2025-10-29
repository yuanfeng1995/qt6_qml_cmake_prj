cmake_minimum_required(VERSION 3.20)

option(WITH_QAPP "Build with Qt Application support" OFF)
option(WITH_UNIT_TESTS "Build with unit tests" OFF)

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(_OUTPUT_DIR_RUNTIME ${CMAKE_SOURCE_DIR}/target/bin_d)
    message(STATUS "Debug Output Dir: ${_OUTPUT_DIR_RUNTIME}")
else ()
    set(_OUTPUT_DIR_RUNTIME ${CMAKE_SOURCE_DIR}/target/bin)
    message(STATUS "Release Output Dir: ${_OUTPUT_DIR_RUNTIME}")
endif ()
set(_OUTPUT_DIR_LIBRARY ${CMAKE_SOURCE_DIR}/target/lib)
set(_OUTPUT_DIR_ARCHIVE ${CMAKE_SOURCE_DIR}/target/lib)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${_OUTPUT_DIR_RUNTIME})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${_OUTPUT_DIR_LIBRARY})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${_OUTPUT_DIR_ARCHIVE})

if (POLICY CMP0141)
    cmake_policy(SET CMP0141 NEW)
    set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<IF:$<AND:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>,$<$<CONFIG:Debug,RelWithDebInfo>:EditAndContinue>,$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>>")
endif ()


project(qt6_qml_cmake_prj LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")

add_subdirectory(commtoolkits)

if (WITH_QAPP)
add_subdirectory(app)
    if(Qt6_DIR)
        set(QWINDOWKIT_BUILD_QUICK ON)
        add_subdirectory(3rd/QWK)
    endif (Qt6_DIR)
endif (WITH_QAPP)

