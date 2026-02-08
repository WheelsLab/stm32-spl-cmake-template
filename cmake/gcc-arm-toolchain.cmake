# GCC ARM 工具链配置

# 设置目标系统为通用裸机系统
set(CMAKE_SYSTEM_NAME Generic)

# 编译目标类型为静态库
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# 交叉编译器路径
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)

# MCU 编译标志：Cortex-M3 架构，使用 thumb 指令集
set(MCU_FLAGS "-mcpu=cortex-m3 -mthumb")

# 初始化各语言的编译标志
set(CMAKE_C_FLAGS_INIT ${MCU_FLAGS})
set(CMAKE_CXX_FLAGS_INIT ${MCU_FLAGS})
set(CMAKE_ASM_FLAGS_INIT ${MCU_FLAGS})

# 编译定义：STM32F10X 中等密度系列
add_compile_definitions(STM32F10X_MD)

# Debug 构建配置：无优化，完整调试信息
set(CMAKE_C_FLAGS_DEBUG "-g3 -fno-omit-frame-pointer")
set(CMAKE_CXX_FLAGS_DEBUG "-g3 -fno-omit-frame-pointer")

# Release 构建配置：优化大小，基础调试信息
set(CMAKE_C_FLAGS_RELEASE "-Os -g")
set(CMAKE_CXX_FLAGS_RELEASE "-Os -g")