library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx is
    generic (
        CLK_FREQ  : integer := 100000000;
        BAUD_RATE : integer := 9600
    );
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        rx       : in  std_logic;
        rx_data  : out std_logic_vector(7 downto 0);
        rx_done  : out std_logic;
        rx_busy  : out std_logic
    );
end uart_rx;

architecture Behavioral of uart_rx is

    constant CLKS_PER_BIT : integer := CLK_FREQ / BAUD_RATE;

    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state : state_type := IDLE;

    signal rx_meta : std_logic := '1';
    signal rx_sync : std_logic := '1';

    signal baud_counter : integer range 0 to CLKS_PER_BIT-1 := 0;
    signal bit_index : integer range 0 to 7 := 0;

    signal rx_shift : std_logic_vector(7 downto 0) := (others => '0');
    signal rx_data_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal rx_done_reg : std_logic := '0';

begin

    rx_data <= rx_data_reg;
    rx_done <= rx_done_reg;
    rx_busy <= '0' when state = IDLE else '1';

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                rx_meta <= '1';
                rx_sync <= '1';
            else
                rx_meta <= rx;
                rx_sync <= rx_meta;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then

            if reset = '1' then
                state <= IDLE;
                baud_counter <= 0;
                bit_index <= 0;
                rx_shift <= (others => '0');
                rx_data_reg <= (others => '0');
                rx_done_reg <= '0';

            else
                rx_done_reg <= '0';

                case state is

                    when IDLE =>
                        baud_counter <= 0;
                        bit_index <= 0;

                        if rx_sync = '0' then
                            state <= START_BIT;
                        end if;

                    when START_BIT =>
                        if baud_counter = (CLKS_PER_BIT / 2) - 1 then
                            baud_counter <= 0;

                            if rx_sync = '0' then
                                state <= DATA_BITS;
                            else
                                state <= IDLE;
                            end if;
                        else
                            baud_counter <= baud_counter + 1;
                        end if;

                    when DATA_BITS =>
                        if baud_counter = CLKS_PER_BIT - 1 then
                            baud_counter <= 0;
                            rx_shift(bit_index) <= rx_sync;

                            if bit_index = 7 then
                                bit_index <= 0;
                                state <= STOP_BIT;
                            else
                                bit_index <= bit_index + 1;
                            end if;
                        else
                            baud_counter <= baud_counter + 1;
                        end if;

                    when STOP_BIT =>
                        if baud_counter = CLKS_PER_BIT - 1 then
                            baud_counter <= 0;

                            if rx_sync = '1' then
                                rx_data_reg <= rx_shift;
                                rx_done_reg <= '1';
                            end if;

                            state <= IDLE;
                        else
                            baud_counter <= baud_counter + 1;
                        end if;

                end case;
            end if;
        end if;
    end process;

end Behavioral;
