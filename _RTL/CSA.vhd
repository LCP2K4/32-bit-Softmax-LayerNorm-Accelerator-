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
     signal b_extended : std_logic_vector(31 downto 0);
begin
    -- CSA
    FA1: full_adder port map(a(0),b(0),c(0),s(0),x(0));
    FA2: full_adder port map(a(1),b(1),c(1),y(0),x(1));
    FA3: full_adder port map(a(2),b(2),c(2),y(1),x(2));
    FA4: full_adder port map(a(3),b(3),c(3),y(2),x(3));
    FA5: full_adder port map(a(4),b(4),c(4),y(3),x(4));
    FA6: full_adder port map(a(5),b(5),c(5),y(4),x(5));
    FA7: full_adder port map(a(6),b(6),c(6),y(5),x(6));
    FA8: full_adder port map(a(7),b(7),c(7),y(6),x(7));
    FA9: full_adder port map(a(8),b(8),c(8),y(7),x(8));
    FA10: full_adder port map(a(9),b(9),c(9),y(8),x(9));
    FA11: full_adder port map(a(10),b(10),c(10),y(9),x(10));
    FA12: full_adder port map(a(11),b(11),c(11),y(10),x(11));
    FA13: full_adder port map(a(12),b(12),c(12),y(11),x(12));
    FA14: full_adder port map(a(13),b(13),c(13),y(12),x(13));
    FA15: full_adder port map(a(14),b(14),c(14),y(13),x(14));
    FA16: full_adder port map(a(15),b(15),c(15),y(14),x(15));
    FA17: full_adder port map(a(16),b(16),c(16),y(15),x(16));
    FA18: full_adder port map(a(17),b(17),c(17),y(16),x(17));
    FA19: full_adder port map(a(18),b(18),c(18),y(17),x(18));
    FA20: full_adder port map(a(19),b(19),c(19),y(18),x(19));
    FA21: full_adder port map(a(20),b(20),c(20),y(19),x(20));
    FA22: full_adder port map(a(21),b(21),c(21),y(20),x(21));
    FA23: full_adder port map(a(22),b(22),c(22),y(21),x(22));
    FA24: full_adder port map(a(23),b(23),c(23),y(22),x(23));
    FA25: full_adder port map(a(24),b(24),c(24),y(23),x(24));
    FA26: full_adder port map(a(25),b(25),c(25),y(24),x(25));
    FA27: full_adder port map(a(26),b(26),c(26),y(25),x(26));
    FA28: full_adder port map(a(27),b(27),c(27),y(26),x(27));
    FA29: full_adder port map(a(28),b(28),c(28),y(27),x(28));
    FA30: full_adder port map(a(29),b(29),c(29),y(28),x(29));
    FA31: full_adder port map(a(30),b(30),c(30),y(29),x(30));
    FA32: full_adder port map(a(31),b(31),c(31),y(30),x(31));

    b_extended <= '0' & y(30 downto 0);
    --total
    CLA_inst: cla_32bit port map(
        A   => x,
        B   => b_extended,
        Cin => '0',
        Sum => s(31 downto 0),
        Cout=> cout
        );

    
end Behavioral;
