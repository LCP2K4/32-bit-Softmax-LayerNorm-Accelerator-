library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity divider is
    Port ( 
        clk   : in std_logic;
        reset : in std_logic;
        start : in std_logic;
        A     : in std_logic_vector(31 downto 0); -- Dividend (S? b? chia)
        B     : in std_logic_vector(31 downto 0); -- Divisor (S? chia)
        O     : out std_logic_vector(31 downto 0); -- Quotient (Th??ng)
        done  : out std_logic
    );
end divider;

architecture Behavioral of divider is

    type state_type is (IDLE, CALC, DONE_STATE);
    signal state : state_type := IDLE;

    signal divisor_reg : unsigned(32 downto 0) := (others => '0');
    signal active_reg  : unsigned(64 downto 0) := (others => '0');
    
    signal bit_count   : integer range 0 to 32 := 0;

begin

    process(clk, reset)
        variable temp : unsigned(32 downto 0);
    begin
        if reset = '1' then
            state       <= IDLE;
            active_reg  <= (others => '0');
            divisor_reg <= (others => '0');
            bit_count   <= 0;
            done        <= '0';
            O           <= (others => '0');
        elsif rising_edge(clk) then
            
            case state is
                when IDLE =>
                    done <= '0';
                    if start = '1' then
                        divisor_reg <= resize(unsigned(B), 33);
                        active_reg <= (others => '0');
                        active_reg(57 downto 26) <= unsigned(A);
                        bit_count <= 32;
                        state <= CALC;
                    end if;
                when CALC =>
                    temp := active_reg(63 downto 31);
                    if temp >= divisor_reg then
                        temp := temp - divisor_reg;
                        active_reg <= temp & active_reg(30 downto 0) & '1';
                    else
                        active_reg <= temp & active_reg(30 downto 0) & '0';
                    end if;
                    if bit_count = 1 then
                        state <= DONE_STATE;
                    else
                        bit_count <= bit_count - 1;
                    end if;
                when DONE_STATE =>
                    done <= '1';
                    O    <= std_logic_vector(active_reg(31 downto 0)); 
                    --& "0000000000000000";
                    state <= IDLE;
                    
            end case;
        end if;
    end process;

end Behavioral;