----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/24/2025 11:23:20 AM
-- Design Name: 
-- Module Name: MSB_8bit - Behavioral
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

entity MSB_8bit is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           o : out STD_LOGIC_VECTOR (2 downto 0);
           done : out STD_LOGIC);
end MSB_8bit;

architecture Behavioral of MSB_8bit is
    component comparator
    GENERIC ( N : integer);
    Port ( A : in STD_LOGIC_VECTOR (2 * N - 1 downto 0);
           B : in STD_LOGIC_VECTOR (N - 1 downto 0);
           ld : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           o : out STD_LOGIC_vector (N - 1 downto 0);
           o_pos : out STD_LOGIC);
     end component;
     component FSM_cmp
     Port (clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           ld1   : out STD_LOGIC;
           ld2   : out STD_LOGIC;
           done  : out STD_LOGIC);
      end component;
     signal temp_4 : STD_LOGIC_VECTOR(3 downto 0);
     signal temp_2 : STD_LOGIC_VECTOR(1 downto 0);
     signal temp_1 : STD_LOGIC_VECTOR(0 downto 0);
     signal ld1,ld2 : STD_LOGIC;
begin
    FSM : FSM_cmp port map(clk,reset,start,ld1,ld2,done);
    cmp4 : comparator generic map (4) port map (A,"0000",start,clk,reset,temp_4,o(2)); 
    cmp2 : comparator generic map (2) port map (temp_4,"00",ld1,clk,reset,temp_2,o(1));        
    cmp1 : comparator generic map (1) port map (temp_2,"0",ld2,clk,reset,temp_1,o(0));
end Behavioral;
