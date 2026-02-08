# STM32F1 标准外设库 (SPL) 配置

# SPL 库根目录
set(STM32F1_SPL_DIR "${CMAKE_SOURCE_DIR}/vendor/STM32F10x_StdPeriph_Driver")

# CMSIS 库目录
set(CMSIS_DIR "${CMAKE_SOURCE_DIR}/vendor/CMSIS")

# SPL 源文件和头文件目录
set(SPL_SOURCE_DIR "${STM32F1_SPL_DIR}/src")
set(SPL_INCLUDE_DIR "${STM32F1_SPL_DIR}/inc")

# SPL 源文件列表
set(SPL_SOURCE
    "${SPL_SOURCE_DIR}/stm32f10x_adc.c"
    "${SPL_SOURCE_DIR}/stm32f10x_bkp.c"
    "${SPL_SOURCE_DIR}/stm32f10x_can.c"
    "${SPL_SOURCE_DIR}/stm32f10x_cec.c"
    "${SPL_SOURCE_DIR}/stm32f10x_crc.c"
    "${SPL_SOURCE_DIR}/stm32f10x_dac.c"
    "${SPL_SOURCE_DIR}/stm32f10x_dbgmcu.c"
    "${SPL_SOURCE_DIR}/stm32f10x_dma.c"
    "${SPL_SOURCE_DIR}/stm32f10x_exti.c"
    "${SPL_SOURCE_DIR}/stm32f10x_flash.c"
    "${SPL_SOURCE_DIR}/stm32f10x_fsmc.c"
    "${SPL_SOURCE_DIR}/stm32f10x_gpio.c"
    "${SPL_SOURCE_DIR}/stm32f10x_i2c.c"
    "${SPL_SOURCE_DIR}/stm32f10x_iwdg.c"
    "${SPL_SOURCE_DIR}/stm32f10x_pwr.c"
    "${SPL_SOURCE_DIR}/stm32f10x_rcc.c"
    "${SPL_SOURCE_DIR}/stm32f10x_rtc.c"
    "${SPL_SOURCE_DIR}/stm32f10x_sdio.c"
    "${SPL_SOURCE_DIR}/stm32f10x_spi.c"
    "${SPL_SOURCE_DIR}/stm32f10x_tim.c"
    "${SPL_SOURCE_DIR}/stm32f10x_usart.c"
    "${SPL_SOURCE_DIR}/stm32f10x_wwdg.c"
    "${SPL_SOURCE_DIR}/misc.c"
    "${STM32F1_SPL_DIR}/system_stm32f10x.c"
)

# 创建静态库
add_library(stm32f1-spl STATIC ${SPL_SOURCE})

# 设置头文件搜索路径（PUBLIC 以便链接此库的目标也能使用）
target_include_directories(stm32f1-spl PUBLIC
    ${STM32F1_SPL_DIR}
    ${SPL_INCLUDE_DIR}
    ${CMSIS_DIR}
    ${CMAKE_SOURCE_DIR}/core
)