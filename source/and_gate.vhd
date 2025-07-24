
library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration
entity and_gate is
    port (
        a : in  std_ulogic;
        b : in  std_ulogic;
        y : out std_ulogic
    );
end entity and_gate;

-- Architecture definition
architecture behavioral of and_gate is
begin
    y <= a and b;
end architecture behavioral;
