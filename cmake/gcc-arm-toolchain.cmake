# GCC ARM 工具链配置
# 用于交叉编译 STM32F1 系列微控制器

# ============================================
# 目标系统配置
# ============================================
set(CMAKE_SYSTEM_NAME Generic)      # 通用裸机系统，无操作系统
set(CMAKE_SYSTEM_PROCESSOR arm)     # ARM 处理器架构

# ============================================
# 编译目标类型配置
# ============================================
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
# 设置 CMake 尝试编译时的目标类型为静态库，避免链接阶段错误

# ============================================
# 工具链前缀配置
# ============================================
set(TOOLCHAIN_PREFIX arm-none-eabi-)
# ARM-none-eabi 工具链前缀，用于裸机 ARM 开发

# ============================================
# 交叉编译器配置
# ============================================
set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}gcc)       # C 编译器
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++)     # C++ 编译器
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_PREFIX}gcc)     # 汇编编译器
set(CMAKE_LINKER ${TOOLCHAIN_PREFIX}ld)            # 链接器
set(CMAKE_OBJCOPY ${TOOLCHAIN_PREFIX}objcopy)     # 二进制转换工具
set(CMAKE_OBJDUMP ${TOOLCHAIN_PREFIX}objdump)     # 反汇编工具
set(CMAKE_SIZE ${TOOLCHAIN_PREFIX}size)           # 文件大小分析工具

# ============================================
# MCU 编译标志配置
# ============================================
set(CMAKE_C_FLAGS_INIT "-mcpu=cortex-m3 -mthumb")
set(CMAKE_CXX_FLAGS_INIT "-mcpu=cortex-m3 -mthumb")
set(CMAKE_ASM_FLAGS_INIT "-mcpu=cortex-m3 -mthumb")
# -mcpu=cortex-m3:   指定目标 CPU 为 Cortex-M3
# -mthumb:           使用 Thumb 指令集（16位指令，节省 Flash 空间）

# ============================================
# 编译定义
# ============================================
add_compile_definitions(STM32F10X_MD)
# STM32F10X_MD: STM32 中等密度系列（Medium Density）
# 用于选择正确的外设库和启动文件
