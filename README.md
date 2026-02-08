# STM32F10x 标准外设库 (SPL) CMake 模板

基于 STM32F103C8T6 的嵌入式开发模板，使用 STM32 标准外设库 (SPL) 和 CMake 构建系统。

> **免责声明**：本项目由 AI 助手 OpenCode 在用户指导下生成，仅供学习和参考。嵌入式开发涉及硬件操作，请务必理解每一行代码的含义后再使用，并对由此产生的任何后果负责。

## 特性

- **CMake 构建系统** - 支持 Debug/Release 构建类型
- **ARM GCC 交叉编译** - 完整的工具链配置
- **STM32F10x SPL** - 包含全部 23 个外设驱动
- **VSCode 集成** - IntelliSense、调试、外设寄存器视图
- **OpenOCD 支持** - 烧录和调试功能
- **CMSIS 核心** - 标准化的 ARM Cortex-M 接口

## 快速开始

```bash
# Debug 构建（用于调试）
cmake -Bbuild -DCMAKE_TOOLCHAIN_FILE=cmake/gcc-arm-toolchain.cmake -DCMAKE_BUILD_TYPE=Debug
cmake --build build

# Release 构建（用于生产）
cmake -Bbuild -DCMAKE_TOOLCHAIN_FILE=cmake/gcc-arm-toolchain.cmake -DCMAKE_BUILD_TYPE=Release
cmake --build build

# 烧录固件
cmake --build build --target flash

# 启动调试服务器
cmake --build build --target debug
```

## 示例代码：LED 闪烁

以下是一个完整的 GPIO 点灯示例，使用 PC13 引脚控制 LED：

```c
#include "stm32f10x.h"

int main(void) {
    // RCC_APB2PeriphClockCmd() - 开启 GPIOC 时钟
    // 所有外设使用前必须先使能其时钟
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);

    // 定义 GPIO 配置结构体
    GPIO_InitTypeDef GPIO_InitStructure = {0};

    // GPIO_Mode_Out_OD - 开漏输出模式（可外部下拉）
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_OD;
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_13;       // PC13 引脚
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz; // IO 响应速度

    // 初始化 GPIO
    GPIO_Init(GPIOC, &GPIO_InitStructure);

    // 主循环：LED 闪烁
    while (1) {
        // GPIO_WriteBit() - 设置引脚输出电平
        GPIO_WriteBit(GPIOC, GPIO_Pin_13, Bit_RESET); // LED 亮（低电平）
        for (uint32_t i = 0; i < 10000000; i++);      // 延时

        GPIO_WriteBit(GPIOC, GPIO_Pin_13, Bit_SET);   // LED 灭（高电平）
        for (uint32_t i = 0; i < 10000000; i++);      // 延时
    }
}
```

### 代码说明

| 代码 | 说明 |
|------|------|
| `RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE)` | 使能 GPIOC 时钟，所有外设使用前必须先使能时钟 |
| `GPIO_InitTypeDef` | GPIO 配置结构体，包含模式、引脚、速度等参数 |
| `GPIO_Init(GPIOC, &GPIO_InitStructure)` | 初始化 GPIO，使用结构体中的配置 |
| `GPIO_WriteBit(GPIOC, GPIO_Pin_13, Bit_RESET/SET)` | 设置引脚输出低/高电平 |
| `for (uint32_t i = 0; i < 10000000; i++);` | 软件延时（简单但不精确） |

## 目录结构

```
stm32-spl-cmake-template/
├── CMakeLists.txt              # 主 CMake 配置文件
├── cmake/
│   ├── stm32f1-spl.cmake       # SPL 库配置
│   └── gcc-arm-toolchain.cmake # ARM 工具链配置
├── .vscode/                    # VSCode 配置
│   ├── c_cpp_properties.json   # IntelliSense 配置
│   ├── launch.json             # 调试配置
│   └── tasks.json              # 任务配置
├── core/                       # 核心启动文件
│   ├── startup_stm32f103xb.s   # 启动文件
│   ├── stm32f10x_it.c          # 中断处理
│   ├── stm32f10x_it.h          # 中断头文件
│   ├── stm32f10x_conf.h        # SPL 配置头文件
│   ├── syscalls.c              # 系统调用
│   └── STM32F103XB_FLASH.ld    # 链接脚本
├── source/
│   └── main.c                  # 主程序入口
├── vendor/
│   ├── STM32F10x_StdPeriph_Driver/  # SPL 库源码
│   │   ├── inc/               # SPL 头文件
│   │   └── src/               # SPL 源文件
│   └── CMSIS/                 # CMSIS 核心
│       └── STM32F1xx.svd      # 外设寄存器视图文件
└── README.md
```

## 工具链

### 一键安装

**Ubuntu/Debian**

```bash
sudo apt install gcc-arm-none-eabi gdb openocd cmake
```

**Arch Linux**

```bash
sudo pacman -S arm-none-eabi-gcc arm-none-eabi-gdb arm-none-eabi-newlib openocd cmake
```

**macOS**

```bash
brew install --cask gcc-arm-embedded openocd cmake
```

**Windows**

下载并安装以下工具：
- ARM GCC: https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm
- OpenOCD: https://github.com/openocd-org/openocd/releases
- CMake: https://cmake.org/download/

### 工具说明

#### arm-none-eabi-gcc / g++ / as / ld / ar

ARM 交叉编译工具链，用于将 C/C++/汇编代码编译为 ARM 架构的静态库、可执行文件。

| 工具 | 功能 |
|------|------|
| gcc | C 编译器 |
| g++ | C++ 编译器 |
| as | 汇编器 |
| ld | 链接器 |
| ar | 静态库归档工具 |

#### arm-none-eabi-gdb

ARM 架构的 GDB 调试器，用于调试嵌入式程序。支持断点、单步执行、查看变量、内存检查等功能。

#### OpenOCD (Open On-Chip Debugger)

开源片上调试器，通过 JTAG 或 SWD 接口与目标芯片通信。提供 GDB 服务器功能，允许远程调试；同时支持固件烧录。

#### CMake

跨平台构建系统，通过 `CMakeLists.txt` 生成 Makefile 或 Ninja 构建文件，管理编译过程和依赖关系。

### VSCode 扩展

- **C/C++** - IntelliSense 代码补全
- **Cortex-Debug** - ARM 调试支持

项目已配置 `.vscode/c_cpp_properties.json`，编译后自动识别头文件。

## 前置条件

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
| `-T core/STM32F103XB_FLASH.ld` | 指定链接脚本，定义内存布局 |
| `-u _printf_float` | 启用浮点数打印支持 |

### newlib-nano

使用 ARM GCC 附带的 newlib-nano 库，可显著减小程序体积。默认情况下，`printf` 不支持浮点数，需通过 `-u _printf_float` 显式启用。

### 嵌入式链接选项详解

在嵌入式开发中，链接选项对程序大小和功能有重要影响：

| 选项 | 说明 |
|------|------|
| `-T <script.ld>` | 指定链接脚本，控制内存布局（Flash、RAM 起始地址和大小） |
| `-Wl,--gc-sections` | 删除未使用的代码和数据，减小固件体积 |
| `-Wl,-Map=output.map` | 生成 map 文件，分析内存占用 |
| `-Wl,--print-memory-usage` | 输出 Flash 和 RAM 使用情况 |
| `-specs=nano.specs` | 使用轻量级 newlib-nano 库 |
| `-specs=nosys.specs` | 不链接系统调用（裸机必需） |
| `-nodefaultlibs` | 不链接标准库，需手动指定 |
| `-nostartfiles` | 不链接启动文件 |
| `-u <symbol>` | 强制链接指定符号（如 `_printf_float`） |
| `-e <entry>` | 指定程序入口点（默认 `_start`） |
| `--entry=Reset_Handler` | 从 Reset_Handler 开始执行 |
| `--just-symbols=<file>` | 仅使用符号，不链接目标文件 |

### 链接脚本说明

链接脚本（`.ld`）定义程序的内存布局：

```ld
/* STM32F103C8T6 内存布局示例 */
MEMORY
{
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 64K   /* 64KB Flash */
    RAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 20K  /* 20KB SRAM */
}
```

> **提示**：链接脚本和启动代码可从 [ST 官方 GitHub](https://github.com/STMicroelectronics/cmsis-device-f1/tree/c8e9a4a4f16b6d2cb2a2083cbe5161025280fb22/Source/Templates/gcc) 获取，也可用 [STM32CubeMX](https://www.st.com/stm32cubemx) 工具生成。

常见 section：
- `.text` - 代码段
- `.rodata` - 只读数据段
- `.data` - 已初始化数据段
- `.bss` - 未初始化数据段

### 其他有用的编译选项

| 选项 | 说明 |
|------|------|
| `-O0` | 不优化，调试时保持代码与源码一一对应 |
| `-O1` | 基础优化，平衡编译速度和执行效率 |
| `-O2` | 标准优化，提高执行速度 |
| `-O3` | 最高优化，可能改变代码执行顺序 |
| `-Os` | 优化代码大小，嵌入式推荐 |
| `-g` | 生成调试信息 |
| `-g3` | 生成完整调试信息，包含宏定义 |
| `-fno-omit-frame-pointer` | 不省略帧指针，调试时栈追踪更准确 |
| `-fno-common` | 不允许未初始化全局变量合并 |
| `-ffunction-sections` | 每个函数单独放在 section |
| `-fdata-sections` | 每个数据对象单独放在 section |
| `-fstack-usage` | 生成栈使用量信息 |
| `-Wall` | 启用所有常见警告 |
| `-Wextra` | 启用额外警告 |
| `-Wpedantic` | 严格遵循 ISO C 标准 |
| `-Werror` | 将警告视为错误 |
| `-mthumb` | 使用 Thumb 指令集（16位，节省代码空间） |
| `-marm` | 使用 ARM 指令集（32位，执行速度更快） |
| `-mcpu=cortex-m3` | 指定目标 CPU 架构 |
| `-mfloat-abi=soft` | 软件浮点运算 |
| `-mfloat-abi=hard` | 硬件浮点运算（需 FPU） |
| `-fshort-enums` | 使用最小枚举类型 |
| `-fshort-wchar` | 使用短宽字符类型 |
| `-ffreestanding` | 独立环境，不依赖标准库 |
| `-fno-builtin` | 不使用内建函数 |

### 其他有用的链接选项

| 选项 | 说明 |
|------|------|
| `-Wl,--gc-sections` | 删除未使用的 section（减小体积） |
| `-Wl,-Map=output.map` | 生成 map 文件 |
| `-Wl,--print-memory-usage` | 输出内存使用情况 |
| `-Wl,--entry=Reset_Handler` | 指定程序入口点 |
| `-Wl,--just-symbols=<file>` | 仅使用符号，不链接目标文件 |
| `-specs=nosys.specs` | 不使用系统调用（裸机必需） |
| `-specs=nano.specs` | 使用轻量级 newlib-nano 库 |
| `-nodefaultlibs` | 不链接默认库 |
| `-nostartfiles` | 不链接启动文件 |
| `-u <symbol>` | 强制链接指定符号 |

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

## 调试

### Debug 构建

调试前请使用 Debug 构建模式，以保留完整的调试信息：

```bash
cmake -Bbuild -DCMAKE_TOOLCHAIN_FILE=cmake/gcc-arm-toolchain.cmake -DCMAKE_BUILD_TYPE=Debug
cmake --build build
```

### VSCode 调试

项目已配置 `.vscode/launch.json`，包含 **Cortex Debug** 配置，支持：

- 断点、单步调试
- 变量查看
- **外设寄存器视图**（需 SVD 文件）

> **提示**：SVD 文件可从 [ST 官网](https://www.st.com/en/microcontrollers-microprocessors/stm32-32-bit-arm-cortex-mcus.html#cad-resources) 下载。

启动调试：按 **F5** 或在运行面板选择配置。

### 外部 GDB 调试

使用 VSCode Tasks 启动 OpenOCD 服务器：

1. **启动 OpenOCD**：`Ctrl+Shift+P` → "Tasks: Run Task" → "OpenOCD Server"
2. **连接 GDB**：

```bash
arm-none-eabi-gdb build/stm32f103c8.elf
(gdb) target remote localhost:3333
(gdb) break main
(gdb) continue
```

### 构建类型对比

| 类型 | 优化级别 | 调试信息 | 链接选项 | 用途 |
|------|---------|---------|---------|------|
| Debug | `-O0` | `-g3` | 无 | 调试、问题排查 |
| Release | `-Os` | `-g` | `--specs=nano.specs` | 生产固件 |

### 调试选项说明

| 选项 | 说明 |
|------|------|
| `-O0` | 不优化，代码执行顺序与源码一致，适合调试 |
| `-O1` | 基础优化，平衡大小和速度 |
| `-O2` | 进一步优化，提高执行速度 |
| `-O3` | 最高优化级别，可能改变代码执行顺序 |
| `-Os` | 优化代码大小，适合嵌入式设备 |
| `-g` | 生成调试信息 |
| `-g3` | 生成完整调试信息，包含宏定义 |
| `--specs=nano.specs` | 使用 newlib-nano，减小代码体积 |
| `-fno-omit-frame-pointer` | 不省略帧指针，调试时栈追踪更准确 |

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

### 添加源文件

编辑 `CMakeLists.txt` 中的 `SOURCES` 列表：

```cmake
set(SOURCES
    source/main.c
    core/startup_stm32f103xb.s
    core/stm32f10x_it.c
    core/syscalls.c
    source/my_driver.c      # 新增源文件
)
```

### 添加头文件搜索路径

编辑 `CMakeLists.txt` 中的 `target_include_directories`：

```cmake
target_include_directories(${EXECUTABLE_NAME} PRIVATE
    ${CMAKE_SOURCE_DIR}/source
    ${CMAKE_SOURCE_DIR}/core
    ${CMAKE_SOURCE_DIR}/my_include    # 新增头文件目录
)
```

## 支持的外设

| 文件 | 主要功能 | 常用接口 |
|------|---------|---------|
| **stm32f10x_adc.c** | 模数转换 | `ADC_Init()`, `ADC_StartCalibration()`, `ADC_SoftwareStartConvCmd()` |
| **stm32f10x_bkp.c** | 备份寄存器 | `BKP_WriteBackupRegister()`, `BKP_ReadBackupRegister()` |
| **stm32f10x_can.c** | CAN 总线 | `CAN_Init()`, `CAN_FilterConfig()`, `CAN_Transmit()` |
| **stm32f10x_cec.c** | HDMI-CEC | `CEC_Init()`, `CEC_Transmit()` |
| **stm32f10x_crc.c** | 循环冗余校验 | `CRC_CalcBlockCRC()`, `CRC_GetCRC()` |
| **stm32f10x_dac.c** | 数模转换 | `DAC_Init()`, `DAC_SetChannel1Data()`, `DAC_SoftwareTriggerCmd()` |
| **stm32f10x_dbgmcu.c** | 调试控制 | `DBGMCU_Config()` |
| **stm32f10x_dma.c** | 直接内存访问 | `DMA_Init()`, `DMA_Cmd()`, `DMA_SetCurrDataCounter()` |
| **stm32f10x_exti.c** | 外部中断 | `EXTI_Init()`, `EXTI_GetFlagStatus()` |
| **stm32f10x_flash.c** | 闪存操作 | `FLASH_Unlock()`, `FLASH_ProgramWord()`, `FLASH_ErasePage()` |
| **stm32f10x_fsmc.c** | 外部存储接口 | `FSMC_NORSRAMInit()`, `FSMC_NORSRAMCmd()` |
| **stm32f10x_gpio.c** | 通用输入输出 | `GPIO_Init()`, `GPIO_ReadInputDataBit()`, `GPIO_WriteBit()` |
| **stm32f10x_i2c.c** | I2C 总线 | `I2C_Init()`, `I2C_GenerateSTART()`, `I2C_Send7bitAddress()` |
| **stm32f10x_iwdg.c** | 独立看门狗 | `IWDG_Enable()`, `IWDG_ReloadCounter()` |
| **stm32f10x_pwr.c** | 电源管理 | `PWR_DeInit()`, `PWR_BackupAccessCmd()`, `PWR_EnterSleepMode()` |
| **stm32f10x_rcc.c** | 复位时钟控制 | `RCC_DeInit()`, `RCC_HSEConfig()`, `RCC_PLLConfig()` |
| **stm32f10x_rtc.c** | 实时时钟 | `RTC_Init()`, `RTC_SetAlarm()`, `RTC_GetAlarm()` |
| **stm32f10x_sdio.c** | SD 卡接口 | `SDIO_Init()`, `SDIO_ReadCard()`, `SDIO_WriteCard()` |
| **stm32f10x_spi.c** | SPI 总线 | `SPI_Init()`, `SPI_I2S_SendData()`, `SPI_I2S_ReceiveData()` |
| **stm32f10x_tim.c** | 定时器 | `TIM_TimeBaseInit()`, `TIM_OCInit()`, `TIM_Cmd()` |
| **stm32f10x_usart.c** | 串口通信 | `USART_Init()`, `USART_SendData()`, `USART_ReceiveData()` |
| **stm32f10x_wwdg.c** | 窗口看门狗 | `WWDG_Enable()`, `WWDG_SetCounter()` |
| **misc.c** | NVIC 中断 | `NVIC_Init()`, `NVIC_SetVectorTable()`, `SysTick_Cmd()` |

## 许可证

本项目采用 GNU General Public License v3.0 许可证开源。

详见 [LICENSE](LICENSE) 文件。

> 注意：本项目包含的 STM32 标准外设库 (SPL) 和 CMSIS 有各自的许可证，使用时需遵守其相应协议。
