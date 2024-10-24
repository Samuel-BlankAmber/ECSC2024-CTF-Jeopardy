LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY FSM_CHALL IS
  PORT (
    o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    enable : IN STD_LOGIC;
    visit_complete : OUT STD_LOGIC;
    RST : IN STD_LOGIC;
    CLK : IN STD_LOGIC
  );
END ENTITY FSM_CHALL;

ARCHITECTURE BEHAVIORAL OF FSM_CHALL IS
  SIGNAL state : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL visited : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
  SIGNAL broken : STD_LOGIC;
BEGIN
  o <= state;
  visit_complete <= '1' WHEN visited = "1111111111111111" ELSE
    '0';

  PROCESS (CLK) BEGIN
    IF RST = '1' THEN
      state <= (OTHERS => '0');
      visited <= (OTHERS => '0');
      broken <= '0';
    ELSE
      IF rising_edge(CLK) THEN
        IF enable = '1' AND broken <= '0' THEN
          IF visited(to_integer(unsigned(state))) = '1' THEN
            broken <= '1';
          ELSE
            visited(to_integer(unsigned(state))) <= '1';
            broken <= broken;
          END IF;

          CASE state IS
            WHEN "0000" =>
              CASE i IS
                WHEN "0100" =>
                  state <= "0001";
                WHEN "1010" =>
                  state <= "0100";
                WHEN OTHERS =>
                  state <= state;
              END CASE;
            WHEN "0001" =>
              CASE i IS
                WHEN "0001" =>
                  state <= "0010";
                WHEN "0101" =>
                  state <= "1010";
                WHEN OTHERS =>
                  state <= state;
              END CASE;
            WHEN "0010" =>
              CASE i IS
                WHEN "0010" =>
                  state <= "0001";
                WHEN "1111" =>
                  state <= "0011";
                WHEN OTHERS =>
                  state <= state;
              END CASE;
            WHEN "0011" =>
              CASE i IS
                WHEN "1010" =>
                  state <= "0110";
                WHEN OTHERS =>
                  state <= state;
              END CASE;
            WHEN "0100" =>
              CASE i IS
                WHEN "1111" =>
                  state <= "1000";
                WHEN "1000" =>
                  state <= "1001";
                WHEN "0000" =>
                  state <= "1100";
                WHEN OTHERS =>
                  state <= state;
              END CASE;
            WHEN "0101" =>
              CASE i IS
                WHEN "1110" =>
                  state <= "0000";
                WHEN "0001" =>
                  state <= "0100";
                WHEN "1111" =>
                  state <= "0110";
                WHEN OTHERS =>
                  state <= state;
              END CASE;
            WHEN "0110" =>
              CASE i IS
                WHEN "0100" =>
                  state <= "0111";
                WHEN OTHERS =>
                  state <= state;
              END CASE;
            WHEN "0111" =>
              CASE i IS
                WHEN "0000" =>
                  state <= "1011";
                WHEN OTHERS =>
                  state <= state;
              END CASE;
            WHEN "1000" =>
              CASE i IS
                WHEN "1111" =>
                  state <= "1010";
                WHEN OTHERS =>
                  state <= state;
              END CASE;
            WHEN "1001" =>
              CASE i IS
                WHEN "1001" =>
                  state <= "0110";
                WHEN "1111" =>
                  state <= "1111";
                WHEN OTHERS =>
                  state <= state;
              END CASE;
            WHEN "1010" =>
              CASE i IS
                WHEN "0010" =>
                  state <= "0111";
                WHEN "0100" =>
                  state <= "1001";
                WHEN OTHERS =>
                  state <= state;
              END CASE;
            WHEN "1011" =>
              CASE i IS
                WHEN "1101" =>
                  state <= "1010";
                WHEN "1011" =>
                  state <= "1110";
                WHEN OTHERS =>
                  state <= state;
              END CASE;
            WHEN "1100" =>
              CASE i IS
                WHEN "1101" =>
                  state <= "1101";
                WHEN OTHERS =>
                  state <= state;
              END CASE;
            WHEN "1101" =>
              CASE i IS
                WHEN "0000" =>
                  state <= "1000";
                WHEN "1000" =>
                  state <= "1110";
                WHEN OTHERS =>
                  state <= state;
              END CASE;
            WHEN "1110" =>
              CASE i IS
                WHEN "1110" =>
                  state <= "0011";
                WHEN "1111" =>
                  state <= "0101";
                WHEN OTHERS =>
                  state <= state;
              END CASE;
            WHEN "1111" =>
              CASE i IS
                WHEN OTHERS =>
                  state <= state;
              END CASE;

            WHEN OTHERS =>
              state <= state;
          END CASE;
        END IF;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE;