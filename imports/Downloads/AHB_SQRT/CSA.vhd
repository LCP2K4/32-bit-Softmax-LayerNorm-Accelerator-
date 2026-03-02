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
    Port ( a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           c : in STD_LOGIC_VECTOR (31 downto 0);
           s : out STD_LOGIC_VECTOR (32 downto 0);
           cout : out STD_LOGIC);
end CSA;

architecture Behavioral of CSA is
    component full_adder
    port ( a : in std_logic;
           b : in std_logic;
           cin : in std_logic;
           s : out std_logic;
           cout : out std_logic);
     end component;
     
     component cla_32bit
     port ( A, B  : in  STD_LOGIC_VECTOR(31 downto 0);
            Cin   : in  STD_LOGIC;
            Sum   : out STD_LOGIC_VECTOR(31 downto 0);
            Cout  : out STD_LOGIC);
     end component;
     
     signal x,y : std_logic_vector (31 downto 0);
     signal temp: std_logic_vector (30 downto 0);
     signal y_extended, x_extended: std_logic_vector(32 downto 0);
     signal cin : std_logic_vector(33 downto 0);
begin
    -- CSA
    G : for i in 0 to 31 generate
        FA: full_adder port map (a(i),b(i),c(i),x(i),y(i));
    end generate G;

    x_extended <= '0' & x;
    y_extended <=  y & '0';
    cin(0) <= '0';
    G2: for i in 0 to 32 generate
        FA1: full_adder port map (x_extended(i),y_extended(i),cin(i),s(i),cin(i+1));
    end generate G2;
    cout <= cin(33);
    
end Behavioral;
