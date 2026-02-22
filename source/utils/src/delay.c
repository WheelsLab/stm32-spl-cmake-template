#include "delay.h"
#include "stm32f10x.h"

/* SysTick 计数器，每 1ms 增加 1 */
volatile uint32_t sys_tick_counter = 0;

/**
 * @brief 延时初始化，配置 SysTick 为 1ms 中断
 * @note 使用 HCLK 时钟 (72MHz)，重装载值为 72000
 *       72000 / 72000000 = 1ms
 */
void delay_init(void) {
    /* 配置 SysTick 时钟源为 HCLK (72MHz)，并设置重装载值为 72000 */
    SysTick_Config(72000);
}

/**
 * @brief 毫秒级延时函数
 * @param ms 延时的毫秒数
 * @note 通过轮询 SysTick 计数器实现延时
 */
void delay_ms(uint32_t ms) {
    uint32_t target = sys_tick_counter + ms;
    while (sys_tick_counter < target);
}
