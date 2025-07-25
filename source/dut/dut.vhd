-- dut

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library dut_lib;

entity dut is
    Port (
        i_clk_h     : in  std_ulogic;         -- system clock
        i_rst_l     : in  std_ulogic;

        -- i2c
        i_scl       : in  std_ulogic;
        i_sda       : in  std_ulogic;
        o_dat       : out std_ulogic_vector(7 downto 0);
        o_dat_rdy_h : out std_ulogic
    );
end dut;

architecture Behavioral of dut is

    signal sys_clk_h : std_ulogic;
    signal sys_rst_l : std_ulogic;

begin

    sys_clk_h <= i_clk_h;

    u0: entity dut_lib.synchronizer
        port map (
            i_dat => '1',
            clk_h => sys_clk_h,
            rst_l => i_rst_l,
            o_dat => sys_rst_l
        );

    u1: entity dut_lib.i2c_receiver
        port map (
            clk_h    => sys_clk_h,
            rst_l    => i_rst_l,
            scl      => i_scl,
            sda      => i_sda,
            data_out => o_dat,
            data_valid => o_dat_rdy_h
        );

end architecture Behavioral;
