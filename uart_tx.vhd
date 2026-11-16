library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
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
        tx_busy  : out std_logic
    );
end uart_tx;

architecture Behavioral of uart_tx is

    constant CLKS_PER_BIT : integer := CLK_FREQ / BAUD_RATE;

    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state : state_type := IDLE;

    signal baud_counter : integer range 0 to CLKS_PER_BIT-1 := 0;
    signal bit_index    : integer range 0 to 7 := 0;
    signal shift_reg    : std_logic_vector(7 downto 0) := (others => '0');

    signal tx_reg : std_logic := '1';

begin

    tx <= tx_reg;
    tx_busy <= '0' when state = IDLE else '1';

    process(clk)
    begin
        if rising_edge(clk) then

            if reset = '1' then
                state        <= IDLE;
                baud_counter <= 0;
                bit_index    <= 0;
                shift_reg    <= (others => '0');
                tx_reg       <= '1';

            else

                case state is

                    when IDLE =>
                        tx_reg <= '1';
                        baud_counter <= 0;
                        bit_index <= 0;

                        if tx_start = '1' then
                            shift_reg <= tx_data;
                            tx_reg <= '0';
                            state <= START_BIT;
                        end if;

                    when START_BIT =>
                        if baud_counter = CLKS_PER_BIT - 1 then
                            baud_counter <= 0;
                            tx_reg <= shift_reg(0);
                            state <= DATA_BITS;
                        else
                            baud_counter <= baud_counter + 1;
                        end if;

                    when DATA_BITS =>
                        if baud_counter = CLKS_PER_BIT - 1 then
                            baud_counter <= 0;

                            if bit_index = 7 then
                                tx_reg <= '1';
                                state <= STOP_BIT;
                            else
                                shift_reg <= '0' & shift_reg(7 downto 1);
                                bit_index <= bit_index + 1;
                                tx_reg <= shift_reg(1);
                            end if;

                        else
                            baud_counter <= baud_counter + 1;
                        end if;

                    when STOP_BIT =>
                        if baud_counter = CLKS_PER_BIT - 1 then
                            baud_counter <= 0;
                            state <= IDLE;
                            tx_reg <= '1';
                        else
                            baud_counter <= baud_counter + 1;
                        end if;

                end case;
            end if;
        end if;
    end process;

end Behavioral;
