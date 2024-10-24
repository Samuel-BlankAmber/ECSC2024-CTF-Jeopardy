LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FPGA_testbench IS
END FPGA_testbench;

ARCHITECTURE test OF FPGA_testbench IS
	SIGNAL clk : STD_LOGIC := '0';
	SIGNAL reset : STD_LOGIC := '0';
	SIGNAL gpio_i : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => 'Z');
	SIGNAL gpio_o : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => 'Z');
BEGIN

	UUT : ENTITY work.TOP_ENTITY
		PORT MAP(
			fpga_gpio_clock => clk,
			fpga_gpio_rst => reset,
			fpga_gpio_i => gpio_i,
			fpga_gpio_o => gpio_o
		);

	stimuli : PROCESS

		PROCEDURE clock IS
		BEGIN
			clk <= '1';
			WAIT FOR 10 ps;
			clk <= '0';
			WAIT FOR 10 ps;
		END clock;

		PROCEDURE rst IS
		BEGIN
			reset <= '1';
			clock;
			reset <= '0';
			WAIT FOR 10 ps;
		END rst;

		PROCEDURE go(i : IN STD_LOGIC_VECTOR(3 DOWNTO 0)) IS
		BEGIN
			gpio_i <= i;
			clock;
		END go;

	BEGIN
		rst;
		go("0100"); -- 0000 -> 0001
		go("0001"); -- 0001 -> 0010
		go("1111"); -- 0010 -> 0011
		go("1010"); -- 0011 -> 0110
		go("0100"); -- 0110 -> 0111
		go("0000"); -- 0111 -> 1011
		go("1011"); -- 1011 -> 1110
		go("1111"); -- 1110 -> 0101
		go("0001"); -- 0101 -> 0100
		go("0000"); -- 0100 -> 1100
		go("1101"); -- 1100 -> 1101
		go("0000"); -- 1101 -> 1000
		go("1111"); -- 1000 -> 1010
		go("0100"); -- 1010 -> 1001
		go("1111"); -- 1001 -> 1111
		WHILE true LOOP
			clock;
		END LOOP;
		WAIT;
	END PROCESS;

END test;