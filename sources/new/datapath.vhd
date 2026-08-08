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
           SUM : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           phase : in STD_LOGIC_VECTOR(1 downto 0);
           mode_sl : in STD_LOGIC;
           input_ld : in STD_LOGIC;
           x_sel : in STD_LOGIC;
           x_ld : in STD_LOGIC;
           out_ld : in STD_LOGIC;
           cnt_ld : in STD_LOGIC;
           div_ld : in STD_LOGIC;
           temp_ld : in STD_LOGIC;
           o : out STD_LOGIC_VECTOR (31 downto 0);
           o_check : out STD_LOGIC_VECTOR (31 downto 0);
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
     
     component mux_4_1 
     generic (
            N : integer := 32     
     );
     port ( A,B,C,D : in STD_LOGIC_VECTOR (N - 1 downto 0);
            sel : in STD_LOGIC_VECTOR(1 downto 0);
            O : out STD_LOGIC_VECTOR(N - 1 downto 0));
     end component;
     component reg
     generic (
            N : integer := 32
     );
     port ( D : in STD_LOGIC_VECTOR (N-1 downto 0);
           load : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (N-1 downto 0));
      end component;
      
      component nt_0
      port ( a : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           o : out STD_LOGIC);
      end component;
      
      component fast_divider
      port (  X     : in  std_logic_vector(31 downto 0);
              Y     : in  std_logic_vector(31 downto 0);
              clk   : in  std_logic;
              rs : in  std_logic;
              start : in  std_logic;
              Q     : out std_logic_vector(31 downto 0);
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
         signal A_in, preadd ,add_in, add_temp: std_logic_vector(31 downto 0);
         signal Cout_temp : std_logic; 
         signal sign,sign_temp : std_logic_VECTOR(0 downto 0);
         signal x_temp, input_temp: std_logic_vector(31 downto 0);
         signal rev_input,rev_output,signed_div_temp : std_logic_vector(31 downto 0);
         signal input_mux, output_mux_temp: std_logic_vector(31 downto 0);
         signal mux_in ,x_in, input_in: std_logic_vector(31 downto 0);
         signal div_out, div_temp: std_logic_vector(31 downto 0);
         signal before_shift : std_logic_vector (32 downto 0);
         signal shift_temp: std_logic_vector(31 downto 0);
         signal o_neg : std_logic_vector(31 downto 0) := (others => '1');
         signal o_temp,o_signed : std_logic_vector (31 downto 0) := (others => '0');
         signal o_tb : std_logic_vector (31 downto 0);
begin



N_FLG : nt_0 port map (A,clk,reset,n_flag_temp);
MUX : mux_4_1 generic map(32) port map(A,A,o_tb,A,phase,A_in);
SEL_MUX : mux_2_1 port map(A_in,shift_temp,x_sel,mux_in);   
X_MUX : mux_4_1 generic map(32) port map (A,SUM,mux_in,o_tb,phase,x_in);
X_REG : reg port map (x_in,x_ld,reset,clk,x_temp);
IN_MUX : mux_4_1 generic map(32) port map (x"00100000",A,o_tb,x"00100000",phase,input_in);
rev_input <= std_logic_vector(unsigned(not input_in) + 1);
SIGNED_INPUT_MUX : mux_2_1 port map (input_in,rev_input,input_in(31),input_mux);
sign(0) <= input_in(31);
SIGNED_REG : reg generic map(1) port map (sign,input_ld,reset,clk,sign_temp);
IN_REG : reg port map (input_mux,input_ld,reset,clk,input_temp);
div : fast_divider port map(input_temp, x_temp, clk, reset,div_ld , div_out, div_flag);
DIVIDER_REG : reg port map (div_out,temp_ld,reset,clk,div_temp);
rev_output <= std_logic_vector(unsigned(not div_temp) + 1);
SIGNED_OUTPUT_MUX : mux_2_1 port map (div_temp,rev_output,sign_temp(0),signed_div_temp);
MODE_MUX : mux_2_1 port map(x"00000000",x"0000000A",mode_sl,preadd);
ADD_MUX : mux_4_1 generic map(32) port map (x"00000000",preadd,x_temp,x"00000000",phase,add_in);
add : CLA_32bit port map (signed_div_temp,add_in,'0',add_temp,cout_temp);
before_shift <= (cout_temp & add_temp);
shift_temp <= before_shift(32 downto 1);
SiGNED_MUX :  mux_2_1 port map (shift_temp,o_neg,n_flag_temp,o_signed);
OUT_MUX :  mux_4_1 generic map(32) port map (add_temp,add_temp,o_signed,add_temp,phase,o_temp);
OUT_REG : reg port map (o_temp, out_ld,reset,clk,o_tb);
compare : cnt_comp port map (clk,reset, cnt_ld,gt_4);
n_flag <= n_flag_temp;
o <= o_tb;
o_check <= signed_div_temp;
end Behavioral;