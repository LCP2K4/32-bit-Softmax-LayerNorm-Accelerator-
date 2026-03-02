----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2025 11:34:47 AM
-- Design Name: 
-- Module Name: cnt_comp_tb - Behavioral
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

entity cnt_comp_tb is
--  Port ( );
end cnt_comp_tb;

architecture Behavioral of cnt_comp_tb is

    component cnt_comp
    port ( reset : in STD_LOGIC;
           load : in STD_LOGIC;
           o : out STD_LOGIC);
    end component;
    
    signal rs : std_logic;
    signal load_tb : std_logic;
    signal o_tb : std_logic;

begin
 uut : cnt_comp port map (rs,load_tb,o_tb);
 
 process begin
    rs <= '1';
    load_tb <= '0';
    wait for 5 ns;
    rs <= '0';
    load_tb <= '1';
    wait for 5 ns;
    load_tb <= '0';
    wait for 5 ns;
    load_tb <= '1';
    wait for 5 ns;
    load_tb <= '0';
    wait for 5 ns;
    load_tb <= '1';
    wait for 5 ns;
    load_tb <= '0';
    wait for 5 ns;
    load_tb <= '1';
    wait for 5 ns;
    load_tb <= '0';
    wait for 5 ns;
    load_tb <= '1';
    wait for 5 ns;
    
    wait;
 end process;

end Behavioral;
