library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_uart_loopback is
end tb_uart_loopback;

architecture Behavioral of tb_uart_loopback is

    constant CLK_FREQ  : integer := 1000000;
    constant BAUD_RATE : integer := 100000;

    signal clk      : std_logic := '0';
    signal reset    : std_logic := '1';

    signal tx_start : std_logic := '0';
    signal tx_data  : std_logic_vector(7 downto 0) := x"A5";
    signal tx       : std_logic;
    signal tx_busy  : std_logic;

    signal rx_data  : std_logic_vector(7 downto 0);
    signal rx_done  : std_logic;
    signal rx_busy  : std_logic;

begin

    clk <= not clk after 5 ns;

    UART_TRANSMITTER: entity work.uart_tx
        generic map (
            CLK_FREQ => CLK_FREQ,
            BAUD_RATE => BAUD_RATE
        )
        port map (
            clk => clk,
            reset => reset,
            tx_start => tx_start,
            tx_data => tx_data,
            tx => tx,
            tx_busy => tx_busy
        );

    UART_RECEIVER: entity work.uart_rx
        generic map (
            CLK_FREQ => CLK_FREQ,
            BAUD_RATE => BAUD_RATE
        )
        port map (
            clk => clk,
            reset => reset,
            rx => tx,
            rx_data => rx_data,
            rx_done => rx_done,
            rx_busy => rx_busy
        );

    stimulus: process
    begin

        reset <= '1';
        wait for 100 ns;

        wait until rising_edge(clk);
        reset <= '0';

        wait for 50 ns;

        tx_start <= '1';
        wait until rising_edge(clk);
        tx_start <= '0';

        wait until rx_done = '1';

        assert rx_data = x"A5"
            report "UART LOOPBACK TEST FAILED!"
            severity error;

        report "UART LOOPBACK TEST PASSED!"
            severity note;

        wait for 100 ns;
        wait;
    end process;

end Behavioral;
