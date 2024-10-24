The main PCB in the shape of a pizza is your target and contains all the challenges, the secondary PCB, the slice, is designed to be your laboratory to solve the challenges.

Let's start with the slice: with its simple design it sports an RP2040 microcontroller, a USB-C port directly connected to it and 12 labeled GPIO (10 free pins and 2 leds). It comes preloaded with MicroPython, but you are free to reprogram it.

The power connector on the slice is as described in the following image:

![SLICE POWER](SLICE_POWER.jpg)


The main PCB is a pizza-shaped board with a SEcube (by Blu5) MCU running at 60MHz: it has a USB-C port that is not used for data, but you need to connect it to a power source in order to power the board; it has a JTAG header that you are forbidden to use (don't worry, you wont be able to do anything with it).

Note: once connected to a USB-C power source CPU LED1 and CPU_LED2 should be on, while CPU_LED3 should be off, if not, please open a ticket on Discord.

Now let's talk about what you can do with the boards:
  - You can admire the beautiful design by Ankhaneko
  - You can use the reset button :)
  - You can connect to the 10 GPIOs on the slice to the GPIO header on the board and the USB-C port

The USB-C port on the pizza is only for power and need to be connected to a power source (like your PC).

The GPIO header is a 20-pin header with the following pinout:

| FUNCTION    | PIN | PIN | FUNCTION           |
| ----------- | --- | --- | ------------------ |
| FPGA_CLOCK  | 1   | 2   | FPGA_RST           |
| FPGA_I0     | 3   | 4   | FPGA_O0            |
| FPGA_I1     | 5   | 6   | FPGA_O1            |
| FPGA_I2     | 7   | 8   | FPGA_O2            |
| FPGA_I3     | 9   | 10  | FPGA_O3            |
| N/A         | 11  | 12  | SLOT_MACHINE_LEVER |
| N/A         | 13  | 14  | N/A                |
| CPU_I2C_SDA | 15  | 16  | CPU_I2C_SCL        |
| CPU_UART_RX | 17  | 18  | CPU_UART_TX        |
| GND         | 19  | 20  | CPU_RST            |

CPU_RST is already configured to be drained to GND by the slice in order to reset the CPU.  
N/A pins are not used for any challenge.
