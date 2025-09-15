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
	--implement: f <= bc'd+a'cd+a'b'c+b'cd
	f <= (b and (not c) and d) or ((not a) and c and d) or ((not a) and (not b) and c) or ((not b) and c and d); 

end architecture equations; 
