LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

ENTITY PRINT_FLAG IS
  PORT (
    CLK : IN STD_LOGIC;
    RST : IN STD_LOGIC;
    enable : IN STD_LOGIC;
    half_byte : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END PRINT_FLAG;

ARCHITECTURE BEHAVIORAL OF PRINT_FLAG IS
  CONSTANT flag : STRING := "ECSC{3xpl0r3_th3_gr4ph} "; -- Input string
  SIGNAL char_idx : INTEGER := 1; -- Character index in string (1 to length of the string)
  SIGNAL nibble_select : STD_LOGIC := '0'; -- '0' for lower 4 bits, '1' for upper 4 bits
  SIGNAL current_char : CHARACTER := ' '; -- Holds the current character being processed
BEGIN

  PROCESS (CLK, RST)
    VARIABLE ascii_val : INTEGER; -- To hold ASCII value of the current character
  BEGIN
    IF RST = '1' THEN
      -- Reset all signals
      char_idx <= 1;
      nibble_select <= '0';
      half_byte <= (OTHERS => '0');
    ELSIF rising_edge(CLK) THEN
      IF enable = '1' THEN
        -- Check if we are still within the string
        IF char_idx <= flag'length THEN
          -- Get the current character from the string
          current_char <= flag(char_idx);

          -- Convert the character to ASCII value
          ascii_val := CHARACTER'pos(current_char);

          -- Assign the half byte based on nibble_select
          IF nibble_select = '0' THEN
            half_byte <= STD_LOGIC_VECTOR(to_unsigned(ascii_val MOD 16, 4)); -- Lower 4 bits (LSB)
            nibble_select <= '1'; -- Switch to upper 4 bits for next clock cycle
          ELSE
            half_byte <= STD_LOGIC_VECTOR(to_unsigned(ascii_val / 16, 4)); -- Upper 4 bits (MSB)
            nibble_select <= '0'; -- Switch back to lower 4 bits
            char_idx <= char_idx + 1; -- Move to the next character
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

END ARCHITECTURE;