LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY TOP_ENTITY IS
  PORT (
    fpga_gpio_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    fpga_gpio_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    fpga_gpio_rst : IN STD_LOGIC;
    fpga_gpio_clock : IN STD_LOGIC
  );
END ENTITY TOP_ENTITY;

ARCHITECTURE STRUCTURAL OF TOP_ENTITY IS
  SIGNAL chall_enable : STD_LOGIC;
  SIGNAL print_enable : STD_LOGIC;
  SIGNAL chall_state : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL print_state : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL visit_complete : STD_LOGIC;
BEGIN
  chall_enable <= '0' WHEN visit_complete = '1' ELSE
    '1';
  print_enable <= NOT chall_enable;
  fpga_gpio_o <= chall_state WHEN chall_enable = '1' ELSE
    print_state;

  chall : ENTITY work.FSM_CHALL
    PORT MAP(
      CLK => fpga_gpio_clock,
      RST => fpga_gpio_rst,
      enable => chall_enable,
      visit_complete => visit_complete,
      i => fpga_gpio_i,
      o => chall_state
    );

  print_flag : ENTITY work.PRINT_FLAG
    PORT MAP(
      CLK => fpga_gpio_clock,
      RST => fpga_gpio_rst,
      enable => print_enable,
      half_byte => print_state
    );
END ARCHITECTURE;