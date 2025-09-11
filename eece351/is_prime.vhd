library IEEE;
use IEEE.std_logic_1164.all;

entity is_prime is
port(
	a,b,c,d: in std_logic;
	f: out std_logic;
);
end entity is_prime

architecture equations of is_prime is

begin
	-- F=a'b'c+bc'd+b'cd+a'bd
	f <= (not a and not b and c) or (c and d) or (not a and b and not c and d); 

end architecture is_prime;
