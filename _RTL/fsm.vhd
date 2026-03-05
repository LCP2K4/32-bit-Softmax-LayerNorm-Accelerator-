----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2025 06:14:21 PM
-- Design Name: 
-- Module Name: controller - Behavioral
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

entity controller is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           n_flag : in STD_LOGIC;
           gt_4 : in STD_LOGIC;
           div_flag : in STD_LOGIC;
           start: in STD_LOGIC;
           mode_sl : in STD_LOGIC;
           mode : out STD_LOGIC;
           preset : out STD_LOGIC := '0';
           input_ld : out STD_LOGIC := '0';
           x_sel : out STD_LOGIC := '0';
           x_ld : out STD_LOGIC := '0';
           out_ld : out STD_LOGIC := '0';
           cnt_ld : out STD_LOGIC := '0';
           div_ld : out STD_LOGIC := '0';
           temp_ld : out STD_LOGIC := '0';
           done : out STD_LOGIC := '0');
end controller;

architecture Behavioral of controller is
    type state_type is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10 );
    signal state, next_state : state_type;
    signal mode_reg : STD_LOGIC;
begin

    process(clk,reset) begin
        if reset = '1' then
            state <= S0;
            mode_reg <= '0';
         elsif rising_edge(clk) then
            if start = '1' and state = S0 then 
                mode_reg <= mode_sl;
                mode <= mode_sl;
                state <= next_state;
            else    state <= next_state;
            end if;
         end if;
    end process;
    
    process(state,div_flag,n_flag,gt_4,start,mode_sl,mode_reg)
    begin
    case state is
        when S0 => 
            preset <= '1';
            x_sel  <= '0';
            x_ld   <= '0';
            input_ld <= '0';
            out_ld <= '0';
            cnt_ld <= '0';
            div_ld <= '0';
            temp_ld <= '0';
            done   <= '0';
            if start = '1' then
                next_state <= S1;
            else next_state <= S0;
            end if;
          
         when S1 =>
            preset <= '0';
            out_ld <= '0';
            cnt_ld <= '0';
            div_ld <= '0';
            temp_ld <= '0';
            x_sel <= '0';
            x_ld <= '1';
            input_ld <= '1';
            done   <= '0';
            next_state <= S2;
          
          when S2 =>
            preset <= '0';
            out_ld <= '0';
            cnt_ld <= '0';
            div_ld <= '0';
            temp_ld <= '0';
            x_sel <= '0';
            x_ld <= '1';
            input_ld <= '0';
            done   <= '0';
            if mode_reg = '1' then next_state <= S3;
            else next_state <= S5;
            end if; 
          when S3 =>
            preset <= '0';
            x_sel  <= '0';
            x_ld   <= '0';
            input_ld <= '0';
            out_ld <= '0';
            cnt_ld <= '0';
            div_ld <= '0';
            temp_ld <= '0';
            done   <= '0';
            if n_flag = '0' then
                next_state <= S4;
            else
                next_state <= S9;
            end if;
            
          when S4 =>
            preset <= '0';
            x_sel  <= '0';
            x_ld   <= '0';
            input_ld <= '0';
            out_ld <= '0';
            cnt_ld <= '0';
            div_ld <= '0';
            temp_ld <= '0';
            done   <= '0';
            if gt_4 = '1' then
                next_state <= S9;
            else
                next_state <= S5;
            end if;
         when S5 =>
            preset <= '0';
            x_sel  <= '0';
            x_ld   <= '0';
            input_ld <= '0';
            out_ld <= '0';
            cnt_ld <= '0';
            div_ld <= '1';
            temp_ld <= '0';
            done   <= '0';
            next_state <= S6;
          when S6 =>
            preset <= '0';
            x_sel  <= '0';
            x_ld   <= '0';
            input_ld <= '0';
            out_ld <= '0';
            cnt_ld <= '0';
            div_ld <= '0';
            temp_ld <= '0';
            done   <= '0';
            if div_flag = '1' then
                next_state <= S7;
            else
                next_state <= S6;
            end if;
          when S7 =>
            preset <= '0';
            cnt_ld <= '0';
            x_sel  <= '0';
            x_ld   <= '0';
            input_ld <= '0';
            out_ld <= '0';
            div_ld <= '0';
            temp_ld <= '1';
            done   <= '0';
            next_state <= S8;
          when S8 =>
            preset <= '0';
            cnt_ld <= '1';
            x_sel  <= '1';
            x_ld   <= '1';
            input_ld <= '0';
            out_ld <= '0';
            div_ld <= '0';
            temp_ld <= '0';
            done   <= '0';
            if mode_reg = '1' then next_state <= S4;
            else next_state <=  S9; 
            end if;
          when S9 =>
            preset <= '0';
            cnt_ld <= '0';
            x_sel  <= '0';
            x_ld   <= '0';
            input_ld <= '0';
            out_ld <= '1';
            div_ld <= '0';
            temp_ld <= '0';
            done   <= '0';
            next_state <= S10;
            
          when S10 =>
            preset <= '0';
            cnt_ld <= '0';
            x_sel  <= '0';
            x_ld   <= '0';
            input_ld <= '0';
            out_ld <= '0';
            div_ld <= '0';
            temp_ld <= '0';
            done   <= '1';
            next_state <= S0;
          
          end case;
    end process;   
            
end Behavioral;
