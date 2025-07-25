library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity i2c_receiver is
    Port (
        clk_h    : in  std_ulogic;         -- system clock
        rst_l    : in  std_ulogic;
        scl      : in  std_ulogic;         -- I2C clock
        sda      : in  std_ulogic;         -- I2C data
        data_out : out std_ulogic_vector(7 downto 0); -- Received data
        data_valid : out std_ulogic       -- Pulses high when data is valid
    );
end entity i2c_receiver;

architecture Behavioral of i2c_receiver is

    signal scl_d : std_ulogic;
    signal scl_q : std_ulogic;

    signal sda_d : std_ulogic;
    signal sda_q : std_ulogic;

    signal cnt_d : std_ulogic_vector(2 downto 0);
    signal cnt_q : std_ulogic_vector(2 downto 0);

    signal dat_d : std_ulogic_vector(7 downto 0);
    signal dat_q : std_ulogic_vector(7 downto 0);

    signal sig_qh : std_ulogic;
    signal sig_dh : std_ulogic;
begin

    scl_d <= scl;
    sda_d <= sda;

    comb_proc: process(all)
    begin
        -- Detect Start Condition: SDA goes low while SCL is high
        if scl = '1' and sda_q = '1' and sda = '0' then
            cnt_d <= (others => '0');
            sig_dh <= '0';
        end if;

        -- Detect Stop Condition: SDA goes high while SCL is high
        if scl = '1' and sda_q = '0' and sda = '1' then
            sig_dh <= '1'; -- Valid data received
        end if;

        -- Sample data on rising edge of SCL while receiving
        if scl_q = '0' and scl = '1' and sda_q = '1' and sda = '0' then
            dat_d <= dat_q & sda;
            if cnt_q = "111" then
                cnt_d <= (others => '0');
            else
                cnt_d <= cnt_q + 1;
            end if;
        end if;
    end process;

    seq_proc : process(rst_l, clk_h)
    begin
        if rst_l = '0' then
            scl_q <= '1';
            sda_q <= '1';

            cnt_q <= (others => '0');

            dat_q <= (others => '0');
            sig_qh <= '0';
        elsif rising_edge(clk_h) then
            scl_q <= scl_d;
            sda_q <= sda_d;

            cnt_q <= cnt_d;

            dat_q <= dat_d;
            sig_qh <= sig_dh;
        end if;
    end process;

    data_valid <= sig_qh;
    data_out <= dat_q;

end architecture Behavioral;
