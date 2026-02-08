# STM32F10x 标准外设库 (SPL) CMake 模板

基于 STM32F103C8T6 的 CMake 项目模板，使用 STM32 标准外设库 (SPL) 进行开发。

## 特性

- CMake 构建系统
- ARM GCC 交叉编译工具链支持
- STM32F10x 标准外设库 (SPL) 完整集成
- 支持 OpenOCD + ST-Link 烧录
- 中等密度 (MD) 系列支持

## 目录结构

```
stm32-spl-cmake-template/
├── CMakeLists.txt              # 主 CMake 配置文件
├── cmake/
│   ├── stm32f1-spl.cmake       # SPL 库配置
│   └── gcc-arm-toolchain.cmake # ARM 工具链配置
├── core/                       # 核心启动文件
│   ├── startup_stm32f10x_md.s  # 启动文件
│   ├── stm32f10x_it.c          # 中断处理
│   ├── syscalls.c              # 系统调用
│   └── STM32F103XX_FLASH.ld    # 链接脚本
├── source/
│   └── main.c                  # 主程序入口
└── vendor/
    ├── STM32F10x_StdPerip_Driver/  # SPL 库源码
    └── CMSIS/                      # CMSIS 核心
```

## 前置条件

### 工具链安装

```bash
# Ubuntu/Debian
sudo apt install gcc-arm-none-eabi openocd

# macOS (Homebrew)
brew install --cask gcc-arm-embedded openocd

# Arch Linux
sudo pacman -S arm-none-eabi-gcc arm-none-eabi-newlib openocd

# Windows
# 下载并安装 ARM GCC: https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm
# 下载并安装 OpenOCD: https://github.com/openocd-org/openocd/releases
```

## 编译与链接选项

本项目使用以下编译和链接选项优化代码体积和功能：

### 编译选项

| 选项 | 说明 |
|------|------|
| `-mcpu=cortex-m3` | 指定 Cortex-M3 内核 |
| `-mthumb` | 使用 Thumb 指令集 |
| `--specs=nano.specs` | 使用 newlib-nano 库，减小代码体积 |

### 链接选项

| 选项 | 说明 |
|------|------|
| `-T core/STM32F103XX_FLASH.ld` | 指定链接脚本，定义内存布局 |
| `-u _printf_float` | 启用浮点数打印支持 |

### newlib-nano

使用 ARM GCC 附带的 newlib-nano 库，可显著减小程序体积。默认情况下，`printf` 不支持浮点数，需通过 `-u _printf_float` 显式启用。

### 其他有用的编译选项

| 选项 | 说明 |
|------|------|
| `-Os` | 优化代码大小（推荐） |
| `-O2` | 优化代码速度 |
| `-g` | 生成调试信息 |
| `-fno-common` | 不允许未初始化的全局变量合并 |
| `-ffunction-sections` | 每个函数单独放在 section |
| `-fdata-sections` | 每个数据对象单独放在 section |
| `-Wall` | 启用所有警告 |
| `-Werror` | 将警告视为错误 |
| `-mno-thumb` | 不使用 Thumb 指令集（使用 ARM 指令） |

### 其他有用的链接选项

| 选项 | 说明 |
|------|------|
| `-Wl,--gc-sections` | 删除未使用的 section（减小体积） |
| `-Wl,-Map=output.map` | 生成 map 文件 |
| `-Wl,--print-memory-usage` | 输出内存使用情况 |
| `-specs=nosys.specs` | 不使用系统调用（裸机） |
| `-nodefaultlibs` | 不链接默认库 |
| `-nostartfiles` | 不链接启动文件 |

### 优化代码体积示例

```cmake
# 在 target_compile_options 中添加
"-Os"
"-ffunction-sections"
"-fdata-sections"

# 在 target_link_options 中添加
"-Wl,--gc-sections"
```

## 编译项目

### 1. 配置 CMake

```bash
cmake -Bbuild -DCMAKE_TOOLCHAIN_FILE=cmake/gcc-arm-toolchain.cmake
```

### 2. 编译

```bash
cmake --build build
```

编译完成后，将在 `build/` 目录下生成 `stm32f103c8.elf` 文件。

## 烧录固件

使用 OpenOCD 烧录到目标芯片：

```bash
cmake --build build --target flash
```

此命令会使用 ST-Link 通过 SWD 接口烧录固件，并自动验证和复位。

## 自定义配置

### 修改可执行文件名

编辑 `CMakeLists.txt` 中的 `EXECUTABLE_NAME` 和链接脚本：

```cmake
set(EXECUTABLE_NAME stm32f103c8)
```

### 修改编译选项

在 `cmake/gcc-arm-toolchain.cmake` 中调整 MCU 标志：

```cmake
set(MCU_FLAGS "-mcpu=cortex-m3 -mthumb")
```

### 添加/移除 SPL 外设

编辑 `cmake/stm32f1-spl.cmake` 中的 `SPL_SOURCE` 列表。

## 支持的外设

- ADC (模数转换)
- BKP (备份寄存器)
- CAN (CAN 总线)
- CEC (HDMI-CEC)
- CRC (循环冗余校验)
- DAC (数模转换)
- DBGMCU (调试微控制器)
- DMA (直接内存访问)
- EXTI (外部中断)
- FLASH (闪存)
- FSMC (灵活静态存储器控制器)
- GPIO (通用输入输出)
- I2C (I2C 总线)
- IWDG (独立看门狗)
- PWR (电源管理)
- RCC (复位时钟控制)
- RTC (实时时钟)
- SDIO (SD 卡接口)
- SPI (SPI 总线)
- TIM (定时器)
- USART (通用同步异步收发器)
- WWDG (窗口看门狗)
- MISC (杂项)

## 许可证

本项目采用 GNU General Public License v3.0 许可证开源。

详见 [LICENSE](LICENSE) 文件。

> 注意：本项目包含的 STM32 标准外设库 (SPL) 和 CMSIS 有各自的许可证，使用时需遵守其相应协议。
