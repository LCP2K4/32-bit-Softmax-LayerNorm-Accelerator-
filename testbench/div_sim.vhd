library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity div_sim is
end div_sim;

architecture Behavioral of div_sim is

    component sqrt_interface
        Port (
            A      : in  STD_LOGIC_VECTOR (31 downto 0);
            clk    : in  STD_LOGIC;
            reset  : in  STD_LOGIC;
            start  : in  STD_LOGIC;
            O      : out STD_LOGIC_VECTOR (31 downto 0);
            n_flag : out STD_LOGIC;
            done   : out STD_LOGIC
        );
    end component;

    signal A_tb     : std_logic_vector(31 downto 0) := (others => '0');
    signal clk_tb   : std_logic := '0';
    signal reset_tb : std_logic := '0';
    signal start_tb : std_logic := '0';
    signal O_tb     : std_logic_vector(31 downto 0);
    signal n_flag_tb : std_logic;
    signal done_tb  : std_logic;

begin
    -- K?t n?i UUT
    uut: sqrt_interface 
        port map(
            A_tb,
            clk_tb,
            reset_tb,
            start_tb,
            O_tb,
            n_flag_tb,
            done_tb
        );

    -- Clock 100MHz
    clk_proc : process
    begin
        while true loop
            clk_tb <= not clk_tb;
            wait for 1 ns;
        end loop;
    end process;

    stim_proc : process
    begin
--        reset_tb <= '1';
--        wait for 20 ns;
--        reset_tb <= '0';
--        wait for 10 ns;

        -- A_tb = negative
        A_tb <= x"f4000000";      
        wait for 1 ns;
        start_tb <= '1';
        wait for 2 ns;
        start_tb <= '0';
        wait until done_tb = '1';
         A_tb <= x"04000000";      
        wait for 1 ns;
        start_tb <= '1';
        wait for 3 ns;
        start_tb <= '0';
        wait until done_tb = '1';
        wait for 1000 ns;
       
        wait;
    end process;

end Behavioral;
