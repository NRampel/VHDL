library IEEE;
use IEEE.std_logic_1164.all;

entity is_prime is
port(
	a,b,c,d: in std_logic; 
	f: out std_logic
);
end entity is_prime; 

architecture equations of is_prime is

begin
	--F=a'b'c+bc'd+b'cd+a'bd
	f <= (not a AND not b AND c) OR (b and NOT c AND d) 
    	OR (NOT b AND c AND d) OR (NOT a AND b AND d) OR (NOT a AND NOT b AND NOT C);  

end architecture equations; 
