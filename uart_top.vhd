library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_top is
    generic (
        CLK_FREQ  : integer := 100000000;
        BAUD_RATE : integer := 9600
    );
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;

        tx_start : in  std_logic;
        tx_data  : in  std_logic_vector(7 downto 0);
        tx       : out std_logic;
        tx_busy  : out std_logic;

        rx       : in  std_logic;
        rx_data  : out std_logic_vector(7 downto 0);
        rx_done  : out std_logic;
        rx_busy  : out std_logic
    );
end uart_top;

architecture Structural of uart_top is

begin

    UART_TX_UNIT: entity work.uart_tx
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

    UART_RX_UNIT: entity work.uart_rx
        generic map (
            CLK_FREQ => CLK_FREQ,
            BAUD_RATE => BAUD_RATE
        )
        port map (
            clk => clk,
            reset => reset,
            rx => rx,
            rx_data => rx_data,
            rx_done => rx_done,
            rx_busy => rx_busy
        );

end Structural;
