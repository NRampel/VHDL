
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex_to_seven is 
    port(
        sw_in : in std_logic_vector(3 downto 0);   
        dec_out : out std_logic_vector(6 downto 0) 
    ); 
end hex_to_seven;

architecture Behavioral of hex_to_seven is
    
begin
    with sw_in select dec_out <=
        "1000000" when x"0", --0
        "1111001" when x"1", --1
        "0100100" when x"2", --2
        "0110000" when x"3", --3
        "0011001" when x"4", --4
        "0010010" when x"5", --5
        "0000010" when x"6", --6
        "1111000" when x"7", --7
        "0000000" when x"8", --8
        "0011000" when x"9", --9
        "0111111" when others; 
end Behavioral;
