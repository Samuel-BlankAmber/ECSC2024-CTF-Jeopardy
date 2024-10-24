#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "i2c.h"
#include "rng.h"

#define REPS 1000

uint8_t i2c_rx_buffer[10];
uint8_t message[11];

uint8_t *gen_message()
{
	size_t len = rand() % 10 + 1;
	message[0] = len;
	for (size_t i = 0; i < len; i++)
	{
		message[i + 1] = rand() % 256;
	}
	return message;
}

void uart_to_i2c_challenge_start()
{
	uint32_t value = 0;
	if (HAL_RNG_GenerateRandomNumber(&hrng, &value) != HAL_OK)
	{
		Error_Handler();
	}
	srand(value);

	int count = 0;

	printf("SEND THESE MESSAGES VIA I2C TO THE ADDRESS 0x42 (1 MESSAGE PER LINE)\r\n");
	while (1)
	{
		gen_message();
		for (size_t i = 1; i < message[0] + 1; i++)
		{
			printf("0x%02X ", message[i]);
		}
		printf("\r\n");

		memset(i2c_rx_buffer, 0, sizeof(i2c_rx_buffer));
		HAL_I2C_Slave_Receive(&hi2c2, i2c_rx_buffer, sizeof(i2c_rx_buffer), HAL_MAX_DELAY);

		if (memcmp(i2c_rx_buffer, message + 1, message[0]) != 0)
		{
			printf("WRONG MESSAGE\r\n");
			break;
		}

		count++;
		if (count == REPS)
		{
			printf("CORRECT, HERE'S THE FLAG: ECSC{f1rs7_st3p5_1nt0_th3_h4rdw4r3_c4t3g0ry}\r\n");
			break;
		}
		printf("CORRECT, AGAIN!\r\n");
	}
}
