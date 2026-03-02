library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity divider is
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;
        start : in  std_logic;
        A     : in  std_logic_vector(31 downto 0); -- Dividend (S? b? chia)
        B     : in  std_logic_vector(31 downto 0); -- Divisor (S? chia)
        O     : out std_logic_vector(31 downto 0); -- Quotient (Th??ng)
        done  : out std_logic
    );
end divider;

architecture Behavioral of divider is
    -- Các tín hi?u tr?ng thái
   signal current_state : integer range 0 to 33 := 0;
    
    -- S? chia: 33 bit ?? ??m b?o tính toán không b? tràn d?u khi tr?
    signal divisor_reg   : unsigned(32 downto 0) := (others => '0');
    
    -- Thanh ghi k?t qu? t?m th?i
    signal result_reg    : unsigned(31 downto 0) := (others => '0');
    
    -- Thanh ghi ho?t ??ng chính (65 bit)
    -- C?u trúc: [ Remainder (33 bit) | Quotient (32 bit) ]
    signal active_reg    : unsigned(64 downto 0) := (others => '0'); 
    
begin

    process(clk, reset)
        -- Bi?n trung gian ?? tính toán logic Shift & Subtract ngay trong 1 clock
        variable v_remainder : unsigned(32 downto 0);
    begin
        if reset = '1' then
            current_state <= 0;
            active_reg    <= (others => '0');
            divisor_reg   <= (others => '0');
            result_reg    <= (others => '0');
            done          <= '0';
            
        elsif rising_edge(clk) then
            
            -- TR?NG THÁI 1: KH?I T?O (START)
            if start = '1' and current_state = 0 then
                current_state <= 0;
                active_reg    <= (others => '0');
                divisor_reg   <= (others => '0');
                result_reg    <= (others => '0');
                done          <= '0';
                done <= '0';
                -- Reset thanh ghi
                active_reg <= (others => '0');
                
                -- QUAN TR?NG: Pre-scale cho Q6.26
                -- ?? gi? ??nh d?ng Fixed Point, ta ph?i nhân A v?i 2^26 tr??c khi chia.
                -- T?c là d?ch trái A 26 bit.
                -- V? trí bit c?a A s? t? 26 ??n 57 (32 bit)
                active_reg(57 downto 26) <= unsigned(A);
                
                -- N?p s? chia
                divisor_reg <= resize(unsigned(B), 33);
                
                -- B?t ??u ??m 32 chu k?
                current_state <= 32;
                done <= '0';
                
            -- TR?NG THÁI 2: TÍNH TOÁN (SHIFT & SUBTRACT)
            elsif current_state > 0 then
                -- B??c 1: Gi? l?p phép d?ch trái (Shift Left)
                -- L?y 33 bit cao nh?t c?a active_reg (t??ng ?ng Remainder) sau khi d?ch
                v_remainder := active_reg(63 downto 31); 
                
                -- B??c 2: So sánh và Tr? (Compare & Subtract)
                if v_remainder >= divisor_reg then
                    -- N?u tr? ???c: C?p nh?t ph?n d? m?i và set bit th??ng = 1
                    v_remainder := v_remainder - divisor_reg;
                    active_reg  <= v_remainder & active_reg(30 downto 0) & '1';
                else
                    -- N?u không tr? ???c: Gi? nguyên và set bit th??ng = 0
                    active_reg  <= v_remainder & active_reg(30 downto 0) & '0';
                end if;
                
                -- Gi?m bi?n ??m
                current_state <= current_state - 1;
                
                -- Ki?m tra k?t thúc
                if current_state = 1 then
                    done <= '1';
                end if;
            
            -- TR?NG THÁI 3: K?T THÚC (IDLE)
            else
                 -- C?p nh?t k?t qu? ra Output (L?y 32 bit th?p c?a active_reg)
                 result_reg <= active_reg(31 downto 0);
            end if;
        end if;
    end process;

    -- Gán ra output
    O <= std_logic_vector(result_reg);

end Behavioral;