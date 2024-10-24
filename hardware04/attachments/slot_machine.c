#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "gpio.h"
#include "tim.h"
#include "rng.h"

uint8_t challenge_enabled = 0;
uint8_t wait_for_start = 1;

#define NUM_WINS 3
#define NUM_CYLINDERS 3
#define CYLINDER_LEN 256
int cylinder_stops[NUM_CYLINDERS] = {0, 0, 0};
int cylinders[NUM_CYLINDERS][CYLINDER_LEN] = {0};
int *running_cylinder;
int *s, n = 0;

void step()
{
  running_cylinder += CYLINDER_LEN;
  s++;
  n = 0;
}

void pull_lever()
{
  if (wait_for_start == 1)
  {
    wait_for_start = 0;
  }
  else
  {
    *s = n;
    step();
  }
}

void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
  if (challenge_enabled && GPIO_Pin == GPIO_PIN_8)
  {
    pull_lever();
  }
}

void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
  if (challenge_enabled && htim->Instance == TIM2)
  {
    pull_lever();
  }
}

void shuffle(int arr[], int n)
{
  uint32_t value = 0;
  if (HAL_RNG_GenerateRandomNumber(&hrng, &value) != HAL_OK)
  {
    Error_Handler();
  }
  srand(value);

  for (int i = n - 1; i > 0; i--)
  {
    int j = rand() % (i + 1);

    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
  }
}

void simple_cylinder(int *sequence, int min, int len)
{
  for (int i = 0; i < len; i++)
  {
    sequence[i] = min + i;
  }
}

void gen_random_sequence(int *sequence, int min, int len)
{
  simple_cylinder(sequence, min, len);
  shuffle(sequence, len);
}

void print_cylinder(int *cylinder, int len)
{
  for (int i = 0; i < len; i++)
  {
    printf("%d\r\n", cylinder[i]);
  }
}

void print_result()
{
  for (int i = 0; i < NUM_CYLINDERS; i++)
  {
    printf("%d\r\n", cylinder_stops[i]);
  }
}

uint8_t play_round()
{
  printf("START ROULETTE\r\n");

  cylinder_stops[0] = 0;
  cylinder_stops[1] = 0;
  cylinder_stops[2] = 0;

  gen_random_sequence(cylinders[0], 1, CYLINDER_LEN);
  gen_random_sequence(cylinders[1], 128, CYLINDER_LEN);
  gen_random_sequence(cylinders[2], 64, CYLINDER_LEN);

  print_cylinder(cylinders[0], CYLINDER_LEN);
  print_cylinder(cylinders[1], CYLINDER_LEN);
  print_cylinder(cylinders[2], CYLINDER_LEN);

  s = cylinder_stops;
  running_cylinder = cylinders[0];
  n = 0;

  challenge_enabled = 1;
  wait_for_start = 1;
  while (wait_for_start == 1)
    ;

  if (HAL_TIM_Base_Start_IT(&htim2) != HAL_OK)
  {
    Error_Handler();
  }

  for (int round = 0; round < NUM_CYLINDERS; round++)
  {
    int rots = 0;
    while (running_cylinder == cylinders[round])
    {
      rots++;
      n = running_cylinder[rots % CYLINDER_LEN];
      if (round >= 1 && rots == cylinder_stops[round - 1])
      {
        *s = n;
        step();
      }
      for (int i = 0; i < 100; i++)
      {
        __asm("nop");
      }
    }
  }

  challenge_enabled = 0;

  if (HAL_TIM_Base_Stop_IT(&htim2) != HAL_OK)
  {
    Error_Handler();
  }

  printf("RESULT\r\n");
  print_result();

  for (int i = 1; i < NUM_CYLINDERS; i++)
  {
    if (cylinder_stops[i - 1] == 0)
      return 0;
    if (cylinder_stops[i - 1] != cylinder_stops[i])
      return 0;
  }
  printf("You won a small jackpot!\r\n");
  return 1;
}

void slot_machine_challenge_start()
{
  for (int i = 0; i < NUM_WINS; i++)
  {
    uint8_t r = play_round();
    if (r == 0)
    {
      printf("Sorry, you didn't win\r\n");
      return;
    }
  }
  printf("BIG Jackpot! Here's the flag: ECSC{REDACTED}\r\n");
}
