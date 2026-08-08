----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2025 05:05:38 PM
-- Design Name: 
-- Module Name: cnt_comp - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cnt_comp is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           load : in STD_LOGIC;
           o : out STD_LOGIC);
end cnt_comp;
    
architecture Behavioral of cnt_comp is
    component cmp_4 
        port ( clk : in STD_LOGIC;
               A : in STD_LOGIC_VECTOR (2 downto 0);
               reset: in std_logic;
               O : out STD_LOGIC);
    end component;
    
    component counter
        port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           load : in STD_LOGIC;
           o : out STD_LOGIC_VECTOR (2 downto 0));
    end component;
    signal temp: std_logic_vector(2 downto 0);
begin
    cnt: counter port map(reset,clk,load,temp);
    cmp : cmp_4 port map(clk,temp,reset,o);
end Behavioral;
