library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- 4-bit Carry Look-Ahead Adder
entity cla_4bit is
    Port (
        A, B  : in  STD_LOGIC_VECTOR(3 downto 0);
        Cin   : in  STD_LOGIC;
        Sum   : out STD_LOGIC_VECTOR(3 downto 0);
        Cout  : out STD_LOGIC;
        Pout  : out STD_LOGIC;  -- group propagate
        Gout  : out STD_LOGIC   -- group generate
    );
end cla_4bit;

architecture Behavioral of cla_4bit is
    signal G, P, C : STD_LOGIC_VECTOR(4 downto 0);
begin
    G(3 downto 0) <= A and B;   -- generate bits
    P(3 downto 0) <= A xor B;   -- propagate bits
    C(0) <= Cin;

    -- carry lookahead logic
    C(1) <= G(0) or (P(0) and C(0));
    C(2) <= G(1) or (P(1) and G(0)) or (P(1) and P(0) and C(0));
    C(3) <= G(2) or (P(2) and G(1)) or (P(2) and P(1) and G(0)) or 
             (P(2) and P(1) and P(0) and C(0));
    C(4) <= G(3) or (P(3) and G(2)) or (P(3) and P(2) and G(1)) or 
             (P(3) and P(2) and P(1) and G(0)) or 
             (P(3) and P(2) and P(1) and P(0) and C(0));

    Sum  <= P(3 downto 0) xor C(3 downto 0);
    Cout <= C(4);
    Gout <= C(4);
    Pout <= P(3) and P(2) and P(1) and P(0);
end Behavioral;

