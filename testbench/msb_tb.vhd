----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/24/2025 05:36:23 PM
-- Design Name: 
-- Module Name: msb_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity msb_tb is
--  Port ( );
end msb_tb;

architecture Behavioral of msb_tb is
    component MSB_8bit
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           o : out STD_LOGIC_VECTOR (2 downto 0);
           done : out STD_LOGIC);
    end component;
    signal A     : STD_LOGIC_VECTOR(7 downto 0);
    signal clk   : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal start : STD_LOGIC := '0';
    signal o     : STD_LOGIC_VECTOR(2 downto 0);
    signal done  : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;
begin
    DUT : MSB_8bit
        port map (
            A     => A,
            clk   => clk,
            reset => reset,
            start => start,
            o     => o,
            done  => done
        );
        clk <= not clk after CLK_PERIOD / 2;
        stim_proc : process
    begin
        -- Reset
        reset <= '1';
        wait for 2 * CLK_PERIOD;
        reset <= '0';

        wait for CLK_PERIOD;

        -- =====================
        -- Test case 1
        -- A = 0001_0100 (20) -> MSB = bit 4
        -- =====================
        A <= "00000100";
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        wait until done = '1';
        wait for CLK_PERIOD;

        -- =====================
        -- Test case 2
        -- A = 1000_0000 (128) -> MSB = bit 7
        -- =====================
        A <= "10101000";
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        wait until done = '1';
        wait for CLK_PERIOD;
        -- =====================
        -- Test case 3
        -- A = 0000_0001 (1) -> MSB = bit 0
        -- =====================
        A <= "00000001";
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        wait until done = '1';
        wait for CLK_PERIOD;

        -- =====================
        -- Test case 4
        -- A = 0000_0000 (0) -> edge case
        -- =====================
        A <= "00000000";
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        wait for 1000 ns;
   end process;

end Behavioral;
