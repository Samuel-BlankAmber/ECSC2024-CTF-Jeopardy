/* USER CODE BEGIN Header */
/**
 ******************************************************************************
 * @file           : main.c
 * @brief          : Main program body
 ******************************************************************************
 * @attention
 *
 * Copyright (c) 2024 STMicroelectronics.
 * All rights reserved.
 *
 * This software is licensed under terms that can be found in the LICENSE file
 * in the root directory of this software component.
 * If no LICENSE file comes with this software, it is provided AS-IS.
 *
 ******************************************************************************
 */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "i2c.h"
#include "rng.h"
#include "tim.h"
#include "usart.h"
#include "gpio.h"
#include "fmc.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include "stm32f4xx_hal_flash.h"

#include "menu.h"
#include "FPGA.h"
#include "FPGA_Setup.h"
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
#define PROGRAM_FPGA
#define FIRMWARE_FPGA_PROGRAM_VERSION 0x01
#define LED1_GPIO GPIOG
#define LED1_PIN GPIO_PIN_3
#define LED2_GPIO GPIOF
#define LED2_PIN GPIO_PIN_10
#define LED3_GPIO GPIOD
#define LED3_PIN GPIO_PIN_12
/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/

/* USER CODE BEGIN PV */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */
#define FLASH_USER_START_ADDR 0x081E0000 // Start address of the reserved flash
#define FLASH_USER_END_ADDR 0x081FFFFF   // End address of the reserved flash

void WriteFlash(uint32_t offset, uint32_t data)
{
  HAL_FLASH_Unlock(); // Unlock flash memory for writing

  // Erase the sector before writing. In this case, Sector 23 is 128Kb
  FLASH_Erase_Sector(FLASH_SECTOR_23, VOLTAGE_RANGE_3);

  // Write a word (32-bit) to the specified address
  HAL_FLASH_Program(TYPEPROGRAM_WORD, FLASH_USER_START_ADDR + offset, data);

  HAL_FLASH_Lock();
}

uint32_t ReadFlash(uint32_t offset)
{
  return *(uint32_t *)FLASH_USER_START_ADDR + offset; // Read the data from flash address
}
/* USER CODE END 0 */

/**
 * @brief  The application entry point.
 * @retval int
 */
int main(void)
{

  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_FMC_Init();
  MX_USART1_UART_Init();
  MX_RNG_Init();
  MX_TIM2_Init();
  MX_I2C2_Init();
  /* USER CODE BEGIN 2 */
  FPGA_init();

  // Disable buffering for stdin or else scanf will not work
  setvbuf(stdin, NULL, _IONBF, 0);

  HAL_GPIO_WritePin(LED3_GPIO, LED3_PIN, 1);
  HAL_GPIO_WritePin(LED1_GPIO, LED1_PIN, 1);

  uint32_t current_fpga_program_version = ReadFlash(0);
  printf("FPGA Program version: 0x%X\r\n", current_fpga_program_version);
  printf("Available Program version: 0x%X\r\n", FIRMWARE_FPGA_PROGRAM_VERSION);

  if (current_fpga_program_version != FIRMWARE_FPGA_PROGRAM_VERSION)
  {
#ifdef PROGRAM_FPGA
    printf("Outdated FPGA Program, updating...\r\n");
    int32_t r_fpga = B5_FPGA_Programming();
    if (r_fpga != 0)
    {
      HAL_GPIO_WritePin(LED2_GPIO, LED2_PIN, 1);
      printf("Error programming FPGA\r\n");
      Error_Handler();
    }
    WriteFlash(0, FIRMWARE_FPGA_PROGRAM_VERSION);
    printf("Programmed FPGA\r\n");
    current_fpga_program_version = ReadFlash(0);
    printf("New FPGA Program version: 0x%X\r\n", current_fpga_program_version);
#else
    printf("Outdated FPGA Program, but PROGRAM_FPGA is disabled\r\n");
#endif
  }

  HAL_GPIO_WritePin(LED1_GPIO, LED1_PIN, 0);

  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  menu();
  while (1)
  {
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
}

/**
 * @brief System Clock Configuration
 * @retval None
 */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Configure the main internal regulator output voltage
   */
  __HAL_RCC_PWR_CLK_ENABLE();
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE3);

  /** Initializes the RCC Oscillators according to the specified parameters
   * in the RCC_OscInitTypeDef structure.
   */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLM = 15;
  RCC_OscInitStruct.PLL.PLLN = 144;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
  RCC_OscInitStruct.PLL.PLLQ = 5;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
   */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV2;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV4;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_1) != HAL_OK)
  {
    Error_Handler();
  }
}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/**
 * @brief  This function is executed in case of error occurrence.
 * @retval None
 */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  //__disable_irq();

  printf("ERROR\r\n");
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef USE_FULL_ASSERT
/**
 * @brief  Reports the name of the source file and the source line number
 *         where the assert_param error has occurred.
 * @param  file: pointer to the source file name
 * @param  line: assert_param error line source number
 * @retval None
 */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     tex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
