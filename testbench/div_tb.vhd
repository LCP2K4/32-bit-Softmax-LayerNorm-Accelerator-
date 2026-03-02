library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity div_tb is
end div_tb;

architecture Behavioral of div_tb is

    component divider
        Port (
            clk   : in  std_logic;
            reset : in  std_logic;
            start : in  std_logic;
            A     : in  std_logic_vector(31 downto 0);
            B     : in  std_logic_vector(31 downto 0);
            O     : out std_logic_vector(31 downto 0);
            done  : out std_logic
        );
    end component;

    signal clk_tb   : std_logic := '0';
    signal reset_tb : std_logic := '1';
    signal start_tb : std_logic := '0';
    signal A_tb     : std_logic_vector(31 downto 0);
    signal B_tb     : std_logic_vector(31 downto 0);
    signal O_tb     : std_logic_vector(31 downto 0);
    signal done_tb  : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Clock generator (100 MHz)
    clk_tb <= not clk_tb after CLK_PERIOD/2;

    -- DUT
    uut : divider
        port map (
            clk   => clk_tb,
            reset => reset_tb,
            start => start_tb,
            A     => A_tb,
            B     => B_tb,
            O     => O_tb,
            done  => done_tb
        );

    -- Stimulus
    stim_proc : process
    begin
        -- Reset
        reset_tb <= '1';
        wait for 20 ns;
        reset_tb <= '0';

        -- Test case 1
        A_tb <= x"0E000000";
        B_tb <= x"08000000";
        start_tb <= '1';

        -- Ch? divider xong
        wait until done_tb = '1';
        wait for CLK_PERIOD;

        -- Test case 2: chia 0
        A_tb <= x"00000000";
        B_tb <= x"00000001";
        start_tb <= '1';
        wait for CLK_PERIOD;
        start_tb <= '0';

        wait until done_tb = '1';
        wait for 50 ns;

        -- K?t thúc mô ph?ng
        wait;
    end process;

end Behavioral;
