----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2025 04:35:04 PM
-- Design Name: 
-- Module Name: reg - Behavioral
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

entity reg is
    Port ( D : in STD_LOGIC_VECTOR (31 downto 0);
           load : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (31 downto 0));
end reg;

architecture Behavioral of reg is
    signal reg : STD_LOGIC_VECTOR(31 downto 0);
begin
    process(clk,reset) begin
    if reset = '1' then
                reg <= ( others => '0');
    elsif rising_edge(clk) then
             if load = '1' then
                reg <= d;
             end if;
         end if;
     end process;
  
     q <= reg;

end Behavioral;
