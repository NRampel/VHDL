library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Vend_SSEG_Driver is
    generic(
        clk_cy : integer := 99_999 
    ); 
    port ( 
        clk, rst : in std_logic; 
        vend_data : in std_logic_vector(27 downto 0);
        seg : out std_logic_vector(6 downto 0); 
        dp : out std_logic; 
        an : out std_logic_vector(3 downto 0)
     );
end Vend_SSEG_Driver;

architecture Behavioral of Vend_SSEG_Driver is
    signal an_reg : std_logic_vector(3 downto 0); 
    signal seg_reg : std_logic_vector(6 downto 0); 
    signal dp_reg : std_logic; 
    signal clk_div : integer range 0 to clk_cy := clk_cy;
    signal digit_sel : integer range 0 to 3 := 0;
    
begin

    process(clk, rst) begin 
        if rst = '1' then 
            clk_div <= clk_cy; 
            digit_sel <= 0;
        elsif rising_edge(clk) then 
            if clk_div = 0 then 
                clk_div <= clk_cy; 
                if digit_sel = 3 then
                    digit_sel <= 0;
                else
                    digit_sel <= digit_sel + 1;
                end if;
            else 
                clk_div <= clk_div - 1; 
            end if; 
        end if; 
    end process; 

    process(digit_sel, vend_data) begin
        case digit_sel is
            when 0 => 
                an_reg <= "1110"; 
                seg_reg <= vend_data(6 downto 0);
                dp_reg <= '1'; 
            when 1 => 
                an_reg <= "1101";
                seg_reg <= vend_data(13 downto 7);
                dp_reg <= '1'; 
            when 2 => 
                an_reg <= "1011";
                seg_reg <= vend_data(20 downto 14);
                if (vend_data = x"5E395A1" or vend_data = x"2422386" or vend_data = x"0CBD7FF") then
                    dp_reg <= '1'; 
                else
                    dp_reg <= '0'; 
                end if;
            when 3 => 
                an_reg <= "0111";
                seg_reg <= vend_data(27 downto 21);
                dp_reg <= '1'; 
            when others =>
                an_reg <= "1111";
                seg_reg <= "1111111";
                dp_reg <= '1';
        end case;
    end process;

    an <= an_reg;
    seg <= seg_reg;
    dp <= dp_reg;

end Behavioral;
