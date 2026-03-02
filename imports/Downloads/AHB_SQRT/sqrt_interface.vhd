----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2025 08:53:34 PM
-- Design Name: 
-- Module Name: sqrt_interface - Behavioral
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

entity sqrt_interface is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           O : out STD_LOGIC_VECTOR (31 downto 0);
           n_flag : out STD_LOGIC;
           done : out STD_LOGIC);
end sqrt_interface;

architecture Behavioral of sqrt_interface is
    component datapath
    port    (A : in STD_LOGIC_VECTOR (31 downto 0);
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
     end component;
     
     component controller
     Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           n_flag : in STD_LOGIC;
           gt_4 : in STD_LOGIC;
           div_flag : in STD_LOGIC;
           start: in STD_LOGIC;
           preset : out STD_LOGIC := '0';
           x_sel : out STD_LOGIC := '0';
           x_ld : out STD_LOGIC := '0';
           out_ld : out STD_LOGIC := '0';
           cnt_ld : out STD_LOGIC := '0';
           div_ld : out STD_LOGIC := '0';
           temp_ld : out STD_LOGIC := '0';
           done : out STD_LOGIC := '0');
     end component;
     
     signal preset_temp,x_sel_temp,x_ld_temp,out_ld_temp,cnt_ld_temp,div_ld_temp, temp_ld_temp, div_flag_temp : std_logic;
     signal gt_4_temp : std_logic;
     signal n_flag_temp : std_logic;
begin
    datapath_connect : datapath port map(A,clk,preset_temp,x_sel_temp,x_ld_temp,out_ld_temp,cnt_ld_temp,div_ld_temp, temp_ld_temp,o,n_flag_temp,gt_4_temp, div_flag_temp);
    controller_connect : controller port map (clk,reset,n_flag_temp,gt_4_temp, div_flag_temp,start,preset_temp,x_sel_temp,x_ld_temp,out_ld_temp,cnt_ld_temp,div_ld_temp,temp_ld_temp,done);
    n_flag <= n_flag_temp;
end Behavioral;
