library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_uart_tx is
end tb_uart_tx;

architecture Behavioral of tb_uart_tx is

    signal clk      : std_logic := '0';
    signal reset    : std_logic := '1';
    signal tx_start : std_logic := '0';
    signal tx_data  : std_logic_vector(7 downto 0) := (others => '0');
    signal tx       : std_logic;
    signal tx_busy  : std_logic;

    constant CLK_FREQ  : integer := 1000000;
    constant BAUD_RATE : integer := 100000;

begin

    uut: entity work.uart_tx
        generic map (
            CLK_FREQ  => CLK_FREQ,
            BAUD_RATE => BAUD_RATE
        )
        port map (
            clk      => clk,
            reset    => reset,
            tx_start => tx_start,
            tx_data  => tx_data,
            tx       => tx,
            tx_busy  => tx_busy
        );

    clk <= not clk after 5 ns;

    stimulus: process
    begin

        reset <= '1';
        wait for 30 ns;

        wait until rising_edge(clk);
        reset <= '0';
        tx_data <= x"A5";
        tx_start <= '1';

        wait until rising_edge(clk);
        tx_start <= '0';

        wait until falling_edge(tx);

        -- Check start bit
        wait for 50 ns;
        assert tx = '0'
            report "START BIT ERROR"
            severity error;

        -- Check 8 data bits (LSB first)
        for i in 0 to 7 loop
            wait for 100 ns;

            assert tx = tx_data(i)
                report "DATA BIT ERROR"
                severity error;
        end loop;

        -- Check stop bit
        wait for 100 ns;

        assert tx = '1'
            report "STOP BIT ERROR"
            severity error;

        report "UART TRANSMISSION TEST PASSED!"
            severity note;

        wait;
    end process;

end Behavioral;