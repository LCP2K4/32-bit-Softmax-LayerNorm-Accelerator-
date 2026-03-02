----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/11/2025 06:24:31 PM
-- Design Name: 
-- Module Name: comparator - Behavioral
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

entity comparator is
    GENERIC ( N : integer );
    Port ( A : in STD_LOGIC_VECTOR (2 * N - 1 downto 0);
           B : in STD_LOGIC_VECTOR (N - 1 downto 0);
           ld : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           o : out STD_LOGIC_vector (N - 1 downto 0);
           o_pos : out STD_LOGIC);
end comparator;

architecture Behavioral of comparator is
begin
    process(reset, clk) begin
        if reset = '1' then
            o <= (others => '0');
            o_pos <= '0';
        elsif clk = '1' and clk'event then
            if ld = '1' then
                if A(2 * N - 1 downto N) = B then
                    o <= A(N - 1 downto 0);
                    o_pos <= '0';
                else
                    o <= A(2 * N - 1 downto N);
                    o_pos <= '1';
                end if;
            end if;
        end if;         
    end process;
            
end Behavioral;
