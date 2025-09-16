--This VHDL code will return all the composite numbers from 0-15
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity is_composite is
port(
    a,b,c,d: in std_logic; 
	f: out std_logic
); 
end is_composite;

architecture equns of is_composite is
   
begin

    f <= (NOT a AND b AND NOT d) OR (a AND NOT b AND NOT c) OR (a AND c AND NOT d)
         OR (a AND b AND NOT C AND NOT d) OR (a AND b AND c); 
    
end architecture equns;
