library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port ( 
        sw : in STD_LOGIC_VECTOR (15 downto 0);
        led : out STD_LOGIC_VECTOR (15 downto 0)
        );
end entity top;

architecture miscellaneous of top is

begin

--led0 is on when both sw0 and sw1 are low
led(0) <= 
    '1' when sw(1 downto 0)="00" 
    else '0'; 

--led1 is on when exactly one of Sw2, sw1, sw0 is high
with sw(2 downto 0 ) select 
    led(1) <=
        '1' when "001",
        '1' when "010",
        '1' when "100",
        '0' when others;  

--led2 is on if the number on sw[3:0] is prime
with sw(3 downto 0) select led(2) <=
    '1' when "1101",
    '1' when "0010",
    '1' when "0111",
    '1' when "1011",
    '1' when "0011",
    '1' when "0101",
    '0' when others;

--set the remaining LEDs off
led(15 downto 3) <= (others => '0');

--This part is to be editied 
--led3 is on if all switches are up
led(3)<= AND(sw); 
   
--led4 is on if an even number of switches is up
led(4) <= XOR(sw); 
--led5 is on if sw[15:8] is equal to sw[7:0]
led(5) <= 
    '1' when sw(15 downto 8)=sw(7 downto 0) 
    else '0';  
--led6 is on if the hex value on the switches is FFA5
led(6) <= '1' when sw=16x"FFA5"; 
    
--led7 is implements the truth table below
--   sw(2) sw(1) sw(0) f
--     0     0     0   1
--     0     0     1   0
--     0     1     0   0
--     0     1     1   1
--     1     0     0   1
--     1     0     1   1
--     1     1     0   0
--     1     1     1   0

with sw(3 downto 0) select led(7)<=
    '1' when "000",
    '1' when "011",  
    '1' when "100",  
    '1' when "101",  
    '0' when others; 

--led[9:8] should indicate the number of switches from sw[3:0] that are up
with sw(3 downto 0) select led(9 downto 8) <=
    "00" when "0000", 
    "11" when "1111", 
    "01" when "0001", 
     elsif when "0010", 
     elsif when "0100", 
     elsif when "1000", 
    "10" when others; 
    
--led[11:10] should indicate the bit position of the least significant 1 in sw[3:0] (use a conditional signal assignment)
led(11 downto 14) <=
    sw(15 downto 14) when sw(0)=sw(1)
    else sw(1 downto 0) when sw(0)=sw(1)
    else NOT (sw(15 downto 14)); 
--led[13:12] should indicate the bit position of the least significant 1 in sw[3:0] (use a selected signal assignment)
with sw(3 downto 0) select led(13 downto 12) <=
    "11" when "1000", 
    "10" when "1100", 
    "10" when "0100", 
    "01" when "0010", 
    "01" when "0110", 
    "01" when "1110", 
    "01" when "1010", 
    "00" when others; 
--led[15:14] should be sw[15:14] when sw[0]==sw[1], sw[1:0] when sw[0]==sw[2], otherwise it should be the inverse of sw[15:14].
led(15 downto 14) <= 
    sw(15 downto 14) when sw(0)=sw(1)
    else sw(1 downto 0) when sw(0)=sw(2)
    else NOT(sw(15 downto 14)); 
    
end architecture miscellaneous;
