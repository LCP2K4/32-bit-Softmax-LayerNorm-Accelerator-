----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2025 04:41:09 PM
-- Design Name: 
-- Module Name: CSA - Behavioral
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

entity CSA is
    Port ( a : in STD_LOGIC_VECTOR (63 downto 0);
           b : in STD_LOGIC_VECTOR (63 downto 0);
           c : in STD_LOGIC_VECTOR (63 downto 0);
           s : out STD_LOGIC_VECTOR (63 downto 0);
           cout : out STD_LOGIC_VECTOR(63 downto 0));
end CSA;

architecture Behavioral of CSA is
    component full_adder
    port ( a : in std_logic;
           b : in std_logic;
           cin : in std_logic;
           s : out std_logic;
           cout : out std_logic);
     end component;
     signal cout_temp : STD_LOGIC_VECTOR(63 downto 0);
begin
    -- CSA
    G : for i in 0 to 63 generate
        FA: full_adder port map (a(i),b(i),c(i),s(i),cout_temp(i));
    end generate G;
    cout <= cout_temp(62 downto 0) & '0';
end Behavioral;
