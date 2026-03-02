----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/11/2025 06:39:38 PM
-- Design Name: 
-- Module Name: Q_integer_datapath - Behavioral
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

entity Q_integer_datapath is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           a_sel : in STD_LOGIC;
           a_ld : in STD_LOGIC;
           o_ld : in STD_LOGIC;
           a_lt_b : out STD_LOGIC;
           o : out STD_LOGIC_VECTOR (31 downto 0));
end Q_integer_datapath;

architecture Behavioral of Q_integer_datapath is

begin


end Behavioral;
