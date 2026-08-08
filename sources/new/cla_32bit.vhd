library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- 32-bit Carry Look-Ahead Adder using 8 CLA_4bit blocks
entity cla_32bit is
    Port (
        A, B  : in  STD_LOGIC_VECTOR(31 downto 0);
        Cin   : in  STD_LOGIC;
        Sum   : out STD_LOGIC_VECTOR(31 downto 0);
        Cout  : out STD_LOGIC
    );
end cla_32bit;

architecture Structural of cla_32bit is
    component cla_4bit
        Port (
            A, B  : in  STD_LOGIC_VECTOR(3 downto 0);
            Cin   : in  STD_LOGIC;
            Sum   : out STD_LOGIC_VECTOR(3 downto 0);
            Cout  : out STD_LOGIC;
            Pout  : out STD_LOGIC;
            Gout  : out STD_LOGIC
        );
    end component;

    signal C : STD_LOGIC_VECTOR(8 downto 0);
    signal P, G : STD_LOGIC_VECTOR(7 downto 0);
begin
    C(0) <= Cin;

    -- Instantiate 8 CLA_4bit modules
    gen_cla: for i in 0 to 7 generate
        cla_i : cla_4bit
            port map (
                A    => A((i*4+3) downto i*4),
                B    => B((i*4+3) downto i*4),
                Cin  => C(i),
                Sum  => Sum((i*4+3) downto i*4),
                Cout => open,
                Pout => P(i),
                Gout => G(i)
            );
    end generate;

    -- Carry lookahead for 8 groups
    C(1) <= G(0) or (P(0) and C(0));
    C(2) <= G(1) or (P(1) and G(0)) or (P(1) and P(0) and C(0));
    C(3) <= G(2) or (P(2) and G(1)) or (P(2) and P(1) and G(0)) or
             (P(2) and P(1) and P(0) and C(0));
    C(4) <= G(3) or (P(3) and G(2)) or (P(3) and P(2) and G(1)) or
             (P(3) and P(2) and P(1) and G(0)) or
             (P(3) and P(2) and P(1) and P(0) and C(0));
    C(5) <= G(4) or (P(4) and G(3)) or (P(4) and P(3) and G(2)) or
             (P(4) and P(3) and P(2) and G(1)) or
             (P(4) and P(3) and P(2) and P(1) and G(0)) or
             (P(4) and P(3) and P(2) and P(1) and P(0) and C(0));
    C(6) <= G(5) or (P(5) and G(4)) or (P(5) and P(4) and G(3)) or
             (P(5) and P(4) and P(3) and G(2)) or
             (P(5) and P(4) and P(3) and P(2) and G(1)) or
             (P(5) and P(4) and P(3) and P(2) and P(1) and G(0)) or
             (P(5) and P(4) and P(3) and P(2) and P(1) and P(0) and C(0));
    C(7) <= G(6) or (P(6) and G(5)) or (P(6) and P(5) and G(4)) or
             (P(6) and P(5) and P(4) and G(3)) or
             (P(6) and P(5) and P(4) and P(3) and G(2)) or
             (P(6) and P(5) and P(4) and P(3) and P(2) and G(1)) or
             (P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and G(0)) or
             (P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and P(0) and C(0));
    C(8) <= G(7) or (P(7) and C(7));
    
    Cout <= C(8);
end Structural;

