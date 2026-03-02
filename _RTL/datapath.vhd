----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2025 06:57:50 PM
-- Design Name: 
-- Module Name: datapath - Behavioral
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

entity datapath is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           x_sel : in STD_LOGIC;
           x_ld : in STD_LOGIC;
           out_ld : in STD_LOGIC;
           cnt_ld : in STD_LOGIC;
           div_ld : in STD_LOGIC;
           temp_ld : in STD_LOGIC;
           o : out STD_LOGIC_VECTOR (31 downto 0);
           n_flag : out STD_LOGIC;
           gt_4 : out STD_LOGIC;
           div_flag : out STD_LOGIC);
end datapath;

architecture Behavioral of datapath is
    component mux_2_1 
    port (A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           SEL : in STD_LOGIC;
           O : out STD_LOGIC_VECTOR (31 downto 0));
     end component;
     
     component reg 
     port ( D : in STD_LOGIC_VECTOR (31 downto 0);
           load : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (31 downto 0));
      end component;
      
      component nt_0
      port ( a : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           o : out STD_LOGIC);
      end component;
      
      component divider
      port (  clk   : in  std_logic;
              reset : in  std_logic;
              start : in  std_logic;
              A     : in  std_logic_vector(31 downto 0);
              B     : in  std_logic_vector(31 downto 0);
              O     : out std_logic_vector(31 downto 0);
              done  : out std_logic);
       end component;
       
       component CLA_32bit 
       port ( A, B  : in  STD_LOGIC_VECTOR(31 downto 0);
            Cin   : in  STD_LOGIC;
            Sum   : out STD_LOGIC_VECTOR(31 downto 0);
            Cout  : out STD_LOGIC
);
        end component;
        
        component cnt_comp
        port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           load : in STD_LOGIC;
           o : out STD_LOGIC);
         end component;
         
         signal n_flag_temp : std_logic;
         signal add_temp: std_logic_vector(31 downto 0);
         signal Cout_temp: std_logic;
         signal x_temp: std_logic_vector(31 downto 0);
         signal mux_temp: std_logic_vector(31 downto 0);
         signal div_temp, div_temp_reg: std_logic_vector(31 downto 0);
         signal before_shift : std_logic_vector (32 downto 0);
         signal shift_temp: std_logic_vector(31 downto 0);
         signal o_neg : std_logic_vector(31 downto 0) := (others => '1');
         signal o_temp : std_logic_vector (31 downto 0) := (others => '0');
         signal o_tb : std_logic_vector (31 downto 0);
begin



N_FLG : nt_0 port map (A,clk,reset,n_flag_temp);    
X_MUX : mux_2_1 port map (A,shift_temp,x_sel,mux_temp);
X_REG : reg port map (mux_temp,x_ld,reset,clk,x_temp);
div : divider port map(clk, reset,div_ld ,A, x_temp, div_temp, div_flag);
--div : CLA_32bit port map (A,x_temp,'0',div_temp,test);
DIV_REG : reg port map (div_temp,temp_ld,reset,clk,div_temp_reg);
add : CLA_32bit port map (div_temp_reg,x_temp,'0',add_temp,cout_temp);
before_shift <= (cout_temp & add_temp);
shift_temp <= before_shift(32 downto 1);
OUT_MUX : mux_2_1 port map (shift_temp,o_neg,n_flag_temp,o_temp);
OUT_REG : reg port map (o_temp, out_ld,reset , clk,o_tb);
compare : cnt_comp port map (clk,reset, cnt_ld,gt_4);
n_flag <= n_flag_temp;
o <= o_tb;
end Behavioral;
