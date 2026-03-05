library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sqrt_interface is
    Port (
        A       : in  STD_LOGIC_VECTOR(31 downto 0);
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        start   : in  STD_LOGIC;
        mode_sl : in  STD_LOGIC;
        O       : out STD_LOGIC_VECTOR(31 downto 0);
        n_flag  : out STD_LOGIC;
        done    : out STD_LOGIC
    );
end sqrt_interface;

architecture Behavioral of sqrt_interface is

    -- datapath
    component datapath
        Port (
            A       : in  STD_LOGIC_VECTOR(31 downto 0);
            clk     : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            mode    : in  STD_LOGIC;
            input_ld: in  STD_LOGIC;
            x_sel   : in  STD_LOGIC;
            x_ld    : in  STD_LOGIC;
            out_ld  : in  STD_LOGIC;
            cnt_ld  : in  STD_LOGIC;
            div_ld  : in  STD_LOGIC;
            temp_ld : in  STD_LOGIC;
            O       : out STD_LOGIC_VECTOR(31 downto 0);
            n_flag  : out STD_LOGIC;
            gt_4    : out STD_LOGIC;
            div_flag: out STD_LOGIC
        );
    end component;

    -- controller
    component controller
        Port (
            clk     : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            n_flag  : in  STD_LOGIC;
            gt_4    : in  STD_LOGIC;
            div_flag: in  STD_LOGIC;
            start   : in  STD_LOGIC;
            mode_sl : in  STD_LOGIC;

            mode    : out STD_LOGIC := '0';
            preset  : out STD_LOGIC := '0';
            input_ld: out STD_LOGIC := '0';
            x_sel   : out STD_LOGIC := '0';
            x_ld    : out STD_LOGIC := '0';
            out_ld  : out STD_LOGIC := '0';
            cnt_ld  : out STD_LOGIC := '0';
            div_ld  : out STD_LOGIC := '0';
            temp_ld : out STD_LOGIC := '0';
            done    : out STD_LOGIC := '0'
        );
    end component;

    -- internal signals
    signal mode, preset_temp, input_ld, x_sel_temp, x_ld_temp,
           out_ld_temp, cnt_ld_temp, div_ld_temp, temp_ld_temp : STD_LOGIC;

    signal gt_4_temp, n_flag_temp, div_flag_temp : STD_LOGIC;

begin

    -- datapath connection
    datapath_connect : datapath
        port map(
            A, clk, preset_temp, mode,
            input_ld, x_sel_temp, x_ld_temp,
            out_ld_temp, cnt_ld_temp, div_ld_temp, temp_ld_temp,
            O, n_flag_temp, gt_4_temp, div_flag_temp
        );

    -- controller connection
    controller_connect : controller
        port map(
            clk, reset, n_flag_temp, gt_4_temp, div_flag_temp,
            start, mode_sl, mode,
            preset_temp, input_ld, x_sel_temp, x_ld_temp,
            out_ld_temp, cnt_ld_temp, div_ld_temp, temp_ld_temp, done
        );

    -- output
    n_flag <= n_flag_temp;

end Behavioral;
