library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity QDS is
    Port (
        R : in  STD_LOGIC_VECTOR(63 downto 0);  -- partial remainder
        D : in  STD_LOGIC_VECTOR(63 downto 0);  -- normalized divisor
        q : out STD_LOGIC_VECTOR(2 downto 0)    -- {-2,-1,0,+1,+2}
    );
end QDS;

architecture Behavioral of QDS is
    signal R_s  : signed(63 downto 0);
    signal D_s  : signed(63 downto 0);
    signal T1   : signed(63 downto 0); 
    signal T2   : signed(63 downto 0); 
begin
    R_s <= signed(R);
    D_s <= signed(D);

    T1 <= shift_right(D_s, 1);         
    T2 <= D_s + shift_right(D_s, 1);    

    process(R_s, T1, T2)
    begin
        if R_s >= T2 then
            q <= "010";   -- +2
        elsif R_s >= T1 then
            q <= "001";   -- +1
        elsif R_s > -T1 then
            q <= "000";   --  0
        elsif R_s > -T2 then
            q <= "111";   -- -1 (2's complement)
        else
            q <= "110";   -- -2 (2's complement)
        end if;
    end process;

end Behavioral;
