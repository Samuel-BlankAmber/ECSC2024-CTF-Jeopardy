import pandas as pd

file = pd.ExcelFile("FSM.xlsx")

matrix = file.parse("Transitions Matrix", header=None)


def fix_number_string_format(x):
    x = str(x)
    if x.lower() == "nan":
        return None

    if "." in x:
        x = x.split(".")[0]

    if len(x) < 4:
        x = x.zfill(4)
    return x


print(
    """LIBRARY ieee;
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
  SIGNAL state : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL visited : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL broken : STD_LOGIC;
  FUNCTION repeat(B : STD_LOGIC; N : NATURAL)
    RETURN STD_LOGIC_VECTOR
    IS
    VARIABLE result : STD_LOGIC_VECTOR(1 TO N);
  BEGIN
    FOR i IN 1 TO N LOOP
      result(i) := B;
    END LOOP;
    RETURN result;
  END FUNCTION;
BEGIN
  PROCESS (CLK, RST) BEGIN
    o <= state;
    IF RST = '1' THEN
      state <= "0000";
      visited <= "0000000000000000";
      broken <= '0';
    ELSE
      IF rising_edge(CLK) THEN
        IF enable = '1' AND broken <= '0' THEN
          IF visited(to_integer(unsigned(state))) = '1' THEN
            broken <= '1';
          ELSE
            broken <= broken;
          END IF;

          visited <= visited OR repeat('0', (visited'length - to_integer(unsigned(state)) - 1)) & "1" & repeat('0', to_integer(unsigned(state)));

          IF visited = "1111111111111111" THEN
            visit_complete <= '1';
          ELSE
            visit_complete <= '0';
          END IF;

          CASE state IS"""
)

for i in range(16):
    f = fix_number_string_format(matrix.iloc[i + 1, 0])
    print('            WHEN "{0}" =>'.format(f))
    print("              CASE i IS")
    for j in range(16):
        t = fix_number_string_format(matrix.iloc[0, j + 1])
        inp = fix_number_string_format(matrix.iloc[i + 1, j + 1])
        if inp is None:
            continue

        print('                WHEN "{0}" =>'.format(inp))
        print('                  state <= "{0}";'.format(t))

    print("                WHEN OTHERS =>")
    print("                  state <= state;")
    print("              END CASE;")

print(
    """
            WHEN OTHERS =>
              state <= state;
          END CASE;
        END IF;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE;"""
)
