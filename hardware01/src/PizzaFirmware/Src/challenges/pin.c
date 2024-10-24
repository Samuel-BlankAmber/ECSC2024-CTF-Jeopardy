#include <stdio.h>
#include <math.h>

#define PIN 7478
#define PIN_LENGTH 4
#define MAX_RETRIES 10

int PIN_MIN = pow(10, PIN_LENGTH - 1);
int PIN_MAX = pow(10, PIN_LENGTH) - 1;

void pin_challenge_start()
{
	for (int i = 0; i < MAX_RETRIES; i++)
	{
		printf("Insert PIN: ");

		int in_pin = 0;
		scanf("%d", &in_pin);
		printf("\r\n");

		if (in_pin < PIN_MIN || in_pin > PIN_MAX)
		{
			printf("Wrong length\r\n");
		}
		else if (in_pin != PIN)
		{
			printf("Wrong PIN\r\n");
		}
		else
		{
			printf("ECSC{1t_0nly_t4k3s_s0m3_r3s3ts}\r\n");
			return;
		}
	}

	printf("Too many retries\r\n");
}
