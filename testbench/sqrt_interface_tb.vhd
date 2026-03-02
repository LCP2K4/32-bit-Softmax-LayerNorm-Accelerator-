----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/26/2025 10:01:24 AM
-- Design Name: 
-- Module Name: sqrt_interface_tb - Behavioral
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
use IEEE.numeric_std.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sqrt_interface_tb is
--  Port ( );
end sqrt_interface_tb;

architecture Behavioral of sqrt_interface_tb is
    component sqrt_interface
        Port (
            A      : in  STD_LOGIC_VECTOR (31 downto 0);
            clk    : in  STD_LOGIC;
            reset  : in  STD_LOGIC;
            start  : in  STD_LOGIC;
            O      : out STD_LOGIC_VECTOR (31 downto 0);
            n_flag : out STD_LOGIC;
            done   : out STD_LOGIC
        );
    end component;

    file textfile : text;
    signal A_tb     : std_logic_vector(31 downto 0) := (others => '0');
    signal clk_tb   : std_logic := '0';
    signal reset_tb : std_logic := '0';
    signal start_tb : std_logic := '0';
    signal O_tb     : std_logic_vector(31 downto 0);
    signal n_flag_tb : std_logic;
    signal done_tb  : std_logic;
begin
    DUT: sqrt_interface 
        port map(
            A_tb,
            clk_tb,
            reset_tb,
            start_tb,
            O_tb,
            n_flag_tb,
            done_tb
        );

clk_process : process begin
        wait for 5 ns;
        clk_tb <= '1';
        wait for 5 ns;
        clk_tb <= '0';
        end process;
dut_process : process
    variable line_buf : line;
    variable i : integer := 0;
    variable check : integer := 0;
    variable check_pass : integer := 0;
    variable A_txt     : std_logic_vector(31 downto 0);
    variable start_txt : std_logic;
    variable reset_txt : std_logic;
    variable sqrt_txt  : std_logic_vector(31 downto 0);
    variable done_txt  : std_logic;
    variable neg_txt   : std_logic;
    variable v_ratio : real;
    variable v_num   : real;
    variable v_den   : real;
begin
    file_open(textfile, "filetestsqrt.txt", read_mode);

    while not endfile(textfile) loop
        readline(textfile, line_buf);

        hread(line_buf, A_txt);
        read(line_buf, start_txt);
        read(line_buf, reset_txt);
        hread(line_buf, sqrt_txt);
        read(line_buf, done_txt);
        read(line_buf, neg_txt);

        A_tb     <= A_txt;
        start_tb <= start_txt;
        reset_tb <= reset_txt;
        wait for 25 ns;
        start_tb <= '0';
        wait until done_tb = '1';
        wait for 5 ns;
        v_num := real(to_integer(signed(O_tb)));
        v_den := real(to_integer(signed(sqrt_txt)));
        if v_den /= 0.0 then
            v_ratio := abs(v_num - v_den)/v_den;
            assert (v_ratio <= 0.01) 
            report "Output mismatch! Location: " & integer'image(i) & " " & real'image(v_num) & " " & real'image(v_den) severity error;
            if not ((v_ratio <= 0.01)) then
                        check := check + 1;
            end if;
            i := i + 1;
        end if;
        assert n_flag_tb = neg_txt
        report "Neg flag match!" severity note;
    end loop;

    file_close(textfile);
    report "Simulation finished, total mismatch: " & integer'image(check) severity note;
    wait;
end process;
end Behavioral;
