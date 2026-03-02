----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2025
-- Design Name: datapath_tb
-- Module Name: datapath_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Testbench for datapath
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath_tb is
end datapath_tb;

architecture Behavioral of datapath_tb is

    component datapath
        Port (
            A       : in  STD_LOGIC_VECTOR (31 downto 0);
            clk     : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            x_sel   : in  STD_LOGIC;
            x_ld    : in  STD_LOGIC;
            out_ld  : in  STD_LOGIC;
            cnt_ld  : in  STD_LOGIC;
            o       : out STD_LOGIC_VECTOR (31 downto 0);
            gt_4    : out STD_LOGIC
        );
    end component;

    signal A_tb       : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal clk_tb     : STD_LOGIC := '0';
    signal reset_tb   : STD_LOGIC := '0';
    signal x_sel_tb   : STD_LOGIC := '0';
    signal x_ld_tb    : STD_LOGIC := '0';
    signal out_ld_tb  : STD_LOGIC := '0';
    signal cnt_ld_tb  : STD_LOGIC := '0';
    signal o_tb       : STD_LOGIC_VECTOR(31 downto 0);
    signal gt_4_tb    : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;

begin

    DUT: datapath
        port map (
            A       => A_tb,
            clk     => clk_tb,
            reset   => reset_tb,
            x_sel   => x_sel_tb,
            x_ld    => x_ld_tb,
            out_ld  => out_ld_tb,
            cnt_ld  => cnt_ld_tb,
            o       => o_tb,
            gt_4    => gt_4_tb
        );

    -- Clock generation
    clk_process : process
    begin
        while TRUE loop
            clk_tb <= '0';
            wait for CLK_PERIOD/2;
            clk_tb <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    stim_proc : process
    begin
        reset_tb <= '1';
        wait for 20 ns;
        reset_tb <= '0';
        
        A_tb <= x"00000036"; 
        
        x_sel_tb <= '0';
        x_ld_tb <= '1';
        wait for CLK_PERIOD;
        x_ld_tb <= '0';

        wait for CLK_PERIOD;
        out_ld_tb <= '1';
        wait for CLK_PERIOD;
        out_ld_tb <= '0';

        for i in 1 to 4 loop
            x_sel_tb <= '1';    
            x_ld_tb <= '1';
            wait for CLK_PERIOD;
            x_ld_tb <= '0';
            wait for CLK_PERIOD;
            out_ld_tb <= '1';
            wait for CLK_PERIOD;
            out_ld_tb <= '0';
        end loop;

        wait for 100 ns;
        assert false report "Simulation finished successfully." severity failure;
    end process;

end Behavioral;
