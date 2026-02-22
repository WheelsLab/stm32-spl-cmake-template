/*
 * ************************************************
 * 
 * @author ICLHC
 * @date 2025/09/28
 * @brief GPIO 点灯实验
 * 
 * STM32 blink LED
 * 
 * CPU:     STM32F103C8
 * PIN:     PC13
 * 
 * ************************************************
*/

#include "stm32f10x.h"
#include "delay.h"


int main(void) {
	// 时钟就像人体的心跳，所有外设的运行都需要时钟
	// GPIO 模块有 4 种 GPIOA/GPIOB/GPIOC/GPIOD
	// PC13 引脚归 GPIOC 管，所以初始化 GPIOC 的时钟
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE); // 开启 GPIOC 时钟
	GPIO_InitTypeDef GPIO_InitStructure = {0};				// 包含 GPIO 配置信息的结构体
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_OD;	// 开漏输出模式
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_13;			// PC13 引脚
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;	// IO 最大输出速度
	GPIO_Init(GPIOC, &GPIO_InitStructure);
	
	delay_init();
	
	while(1){
		GPIO_WriteBit(GPIOC, GPIO_Pin_13, Bit_RESET); // 亮
		delay_ms(200);
		GPIO_WriteBit(GPIOC, GPIO_Pin_13, Bit_SET); // 灭
		delay_ms(1500);
	};
}
