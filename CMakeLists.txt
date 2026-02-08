# CMake 最低版本要求
cmake_minimum_required(VERSION 3.15)

# 项目名称和语言配置
project(stm32f103c6-template
        LANGUAGES C ASM)

# 导出编译命令以便 IDE 使用
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 编译定义：使用标准外设驱动库
add_compile_definitions(USE_STDPERIPH_DRIVER)

# 源文件列表
set(SOURCES
    source/main.c
    core/startup_stm32f103xb.s
    core/stm32f10x_it.c
    core/syscalls.c
    )

# 可执行文件名称
set(EXECUTABLE_NAME 
    stm32f103c8)

# 创建可执行目标
add_executable(${EXECUTABLE_NAME} ${SOURCES})

# 设置输出文件名称
set_target_properties(${EXECUTABLE_NAME} PROPERTIES OUTPUT_NAME "${EXECUTABLE_NAME}.elf")

# 编译选项：使用 nano.specs 减小代码体积
target_compile_options(${EXECUTABLE_NAME} PRIVATE
    --specs=nano.specs)

# 链接选项
target_link_options(${EXECUTABLE_NAME} PRIVATE
    -T ${CMAKE_SOURCE_DIR}/core/STM32F103XB_FLASH.ld
    -u _printf_float)

# 头文件搜索路径
target_include_directories(${EXECUTABLE_NAME} PRIVATE
    ${CMAKE_SOURCE_DIR}/source
    ${CMAKE_SOURCE_DIR}/core
)

# 包含 SPL 库配置并链接
include(cmake/stm32f1-spl.cmake)
target_link_libraries(${EXECUTABLE_NAME} stm32f1-spl)   

# 烧录配置：OpenOCD + ST-Link
set(PROGRAMMER openocd)
set(PROGRAMMER_FLAGS -f interface/stlink.cfg -f target/stm32f1x.cfg)

# 创建 flash 自定义目标
add_custom_target(flash
    COMMAND ${PROGRAMMER} ${PROGRAMMER_FLAGS} -c "program $<TARGET_FILE:${EXECUTABLE_NAME}> verify reset exit"
    DEPENDS ${EXECUTABLE_NAME}
    VERBATIM)

# 创建 debug 自定义目标：启动 OpenOCD 服务器
add_custom_target(debug
    COMMAND ${PROGRAMMER} ${PROGRAMMER_FLAGS}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS ${EXECUTABLE_NAME}
    VERBATIM)