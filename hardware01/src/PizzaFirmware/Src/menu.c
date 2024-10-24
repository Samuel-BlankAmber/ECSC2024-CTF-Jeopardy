#include <stdio.h>

char *pizza =
    "                         _______\r\n"
    "                        |  ~~--.\r\n"
    "                        |%=@%%/\r\n"
    "                        |o%%%/\r\n"
    "                     __ |%%o/\r\n"
    "               _,--~~ | |(_/ ._\r\n"
    "            ,/'  m%%%%| |o/ /  `\\.\r\n"
    "           /' m%%o(_)%| |/ /o%%m `\\\r\n"
    "         /' %%@=%o%%%o|   /(_)o%%% `\\\r\n"
    "        /  %o%%%%%=@%%|  /%%o%%@=%%  \\\r\n"
    "       |  (_)%(_)%%o%%| /%%%=@(_)%%%  |\r\n"
    "       | %%o%%%%o%%%(_|/%o%%o%%%%o%%% |\r\n"
    "       | %%o%(_)%%%%%o%(_)%%%o%%o%o%% |\r\n"
    "       |  (_)%%=@%(_)%o%o%%(_)%o(_)%  |\r\n"
    "        \\ ~%%o%%%%%o%o%=@%%o%%@%%o%~ /\r\n"
    "         \\. ~o%%(_)%%%o%(_)%%(_)o~ ,/\r\n"
    "           \\_ ~o%=@%(_)%o%%(_)%~ _/\r\n"
    "             `\\_~~o%%%o%%%%%~~_/'\r\n"
    "                `--..____,,--'\r\n";

void menu()
{
  printf("Welcome to the pizza challenges\r\n");
  printf("%s", pizza);
  printf("1. UART to I2C\r\n");
  printf("2. PIN\r\n");
  printf("3. Slot Machine\r\n");
  printf("> ");

  int choice = 0;
  scanf("%d", &choice);
  printf("\r\n");
  switch (choice)
  {
  case 1:
    uart_to_i2c_challenge_start();
    break;
  case 2:
    pin_challenge_start();
    break;
  case 3:
    slot_machine_challenge_start();
    break;
  default:
    printf("Invalid choice\r\n");
    break;
  }
}