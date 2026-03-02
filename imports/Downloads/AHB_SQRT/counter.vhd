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

entity counter is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           load : in STD_LOGIC;
           o : out STD_LOGIC_VECTOR (2 downto 0));
end counter;
    
architecture Behavioral of counter is
    signal cnt : unsigned(2 downto 0) := (others => '0');
begin
    process(clk,reset) begin
        if reset = '1' then cnt <= (others => '0');
        elsif rising_edge(clk) then
         if load = '1' then cnt <= cnt + 1;
         end if;
        end if;
    end process;
    o <= std_logic_vector(cnt);
end Behavioral;
