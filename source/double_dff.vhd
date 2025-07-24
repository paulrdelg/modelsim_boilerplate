
library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration
entity synchronizer is
    port (
        i_dat : in  std_ulogic;
        clk_h : in  std_ulogic;
        rst_l : in  std_ulogic;
        o_dat : out std_ulogic
    );
end entity synchronizer;

-- Architecture definition
architecture behavioral of synchronizer is
    signal d1 : std_ulogic;
    signal d2 : std_ulogic;
    signal q1 : std_ulogic;
    signal q2 : std_ulogic;
begin
    com_proc: process(all)
    begin
        d1 <= i_dat;
        d2 <= q1;
    end process com_proc;

    seq_proc : process(clk_h, rst_l)
    begin
        if rst_l = '0' then
            q1 <= '0';
            q2 <= '0';
        else
            if rising_edge(clk_h) then
                q1 <= d1;
                q2 <= d2;
            end if;
        end if;
    end process seq_proc;

    o_dat <= q2;
end architecture behavioral;
