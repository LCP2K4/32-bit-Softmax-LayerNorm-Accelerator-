----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2025 05:15:49 PM
-- Design Name: 
-- Module Name: cmp_4 - Behavioral
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

entity cmp_4 is
    Port ( clk : in STD_LOGIC;
           A : in STD_LOGIC_VECTOR (2 downto 0);
           reset: in std_logic;
           O : out STD_LOGIC);
end cmp_4;

architecture Behavioral of cmp_4 is
    signal temp : std_logic;
begin
    process(clk,reset) begin
        if reset = '1' then O <= '0';
        elsif rising_edge(clk) then 
        if A >= "100" then
            O <= '1';
         else
            O <= '0';
        end if;
       end if;
    end process;

end Behavioral;
