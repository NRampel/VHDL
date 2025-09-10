
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd_to_seven is 
    port(
        sw_in : in std_logic_vector(3 downto 0);   
        dec_out : out std_logic_vector(6 downto 0) 
    ); 
end bcd_to_seven;

architecture Behavioral of bcd_to_seven is
begin
    with sw_in select dec_out <=
        "1000000" when "0000", --0
        "1111001" when "0001", --1
        "0100100" when "0010", --2
        "0110000" when "0011", --3
        "0011001" when "0100", --4
        "0010010" when "0101", --5
        "0000010" when "0110", --6
        "1111000" when "0111", --7
        "0000000" when "1000", --8
        "0011000" when "1001", --9
        "0111111" when others; --Everything else

end Behavioral;
