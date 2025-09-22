cmake_minimum_required(VERSION 3.20)

set(APP_NAME "qml_demo")
set(APP_DESC "qml demo by livio")
set(APP_ICON_PATH "${CMAKE_CURRENT_SOURCE_DIR}/rc/app.ico")
set(COMPANY_NAME "example company")
set(COPYRIGHT_YEAR "2025")

project(${APP_NAME} VERSION 0.0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_compile_options(
    "$<$<CXX_COMPILER_ID:MSVC>:/utf-8>"
    "$<$<CONFIG:Debug>:/ZI>"
)

if (WIN32)
    # 配置RC模板
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/rc/app.rc.in
        ${CMAKE_CURRENT_BINARY_DIR}/app.rc
        @ONLY
    )
    set(APP_RC ${CMAKE_CURRENT_BINARY_DIR}/app.rc)
endif (WIN32)

find_package(Qt6 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.9)

message(STATUS QT_VERSION=${Qt6_VERSION})
if (Qt6_VERSION VERSION_GREATER_EQUAL "6.6.0")
    qt_policy(SET QTP0004 NEW)
endif()


qt_add_executable(${APP_NAME}
    ${APP_RC}
    src/main.cc
)
target_compile_definitions(${APP_NAME} PRIVATE
    APP_NAME="${APP_NAME}"
    APP_DESC="${APP_DESC}"
    APP_ICON_PATH="${APP_ICON_PATH}"
    COMPANY_NAME="${COMPANY_NAME}"
    COPYRIGHT_YEAR="${COPYRIGHT_YEAR}"
)

qt_add_qml_module(${APP_NAME}
    URI ${APP_NAME}
    VERSION 1.0
    QML_FILES
    qml/Main.qml
    qml/FramelessWindow.qml
)

set_target_properties(${APP_NAME} PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    DEBUG_POSTFIX "d"
)

target_link_libraries(${APP_NAME} PRIVATE
    Qt6::Quick
    QWindowKit::Quick
)

include(GNUInstallDirs)
install(TARGETS ${APP_NAME}
    BUNDLE DESTINATION ..
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)


add_custom_command(TARGET ${APP_NAME} POST_BUILD
    COMMAND ${WINDEPLOYQT_EXECUTABLE} --qmldir ${CMAKE_CURRENT_SOURCE_DIR} $<TARGET_FILE:${APP_NAME}>
)
