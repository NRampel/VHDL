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
	f <= (not a and d) or (not b and not c and d) or (not a and not b and c) or (b and c and d);  

end architecture is_prime;
