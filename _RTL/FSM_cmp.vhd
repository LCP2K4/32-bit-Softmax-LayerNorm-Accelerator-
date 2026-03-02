----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/24/2025 05:06:35 PM
-- Design Name: 
-- Module Name: FSM_cmp - Behavioral
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

entity FSM_cmp is
  Port (   clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           ld1   : out STD_LOGIC;
           ld2   : out STD_LOGIC;
           done  : out STD_LOGIC);
end FSM_cmp;

architecture Behavioral of FSM_cmp is
    type state_type is (S0,S1,S2,S3 );
    signal state, next_state : state_type;
begin
    process(clk,reset) begin
        if reset = '1' then
            state <= S0;
         elsif rising_edge(clk) then
            state <= next_state;
         end if;
    end process;
    process(start,state) begin
        case state is 
            when S0 =>
                ld1 <= '0';
                ld2 <= '0';
                done <= '0';
                if start = '1' then
                    next_state <= S1;
                 else 
                    next_state <= S0;
                 end if;
             when S1 =>
                  ld1 <= '1';
                  ld2 <= '0';
                  done <= '0';
                  next_state <= S2;
              when S2 =>
                   ld1 <= '0';
                   ld2 <= '1';
                   next_state <= S3;
               when S3 =>
                   ld1 <= '0';
                   ld2 <= '0';
                   done <= '1';
                   next_state <= S0;
               when others =>
                   next_state <= S0;
               end case;
     
                                
    end process;
end Behavioral;
