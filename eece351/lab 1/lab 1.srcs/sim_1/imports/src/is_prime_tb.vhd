library IEEE;
use IEEE.std_logic_1164.all;

entity is_prime_tb is
end entity is_prime_tb;

architecture basic_testbench of is_prime_tb is

	signal a_sig,b_sig,c_sig,d_sig: std_logic;
	signal f_sig: std_logic;
	
	component is_prime is
	port(
		a,b,c,d: in std_logic;
		f: out std_logic
    	);
	end component is_prime;

begin
-- The device to be tested
	MUT1: is_prime port map( a => a_sig, b => b_sig, c => c_sig, d => d_sig, f => f_sig);

-- Main Testbench Process
	MAIN_TB: process begin

    	a_sig <= '0'; b_sig <= '0'; c_sig <= '0'; d_sig <= '0';
    	wait for 10 ns;
    	assert(f_sig='0') report "Circuit failed for abcd=0000" severity warning;

	a_sig <= '0'; b_sig <= '0'; c_sig <= '0'; d_sig <= '1';
    	wait for 10 ns;
    	assert(f_sig='0') report "Circuit failed for abcd=0001" severity warning;
    	
        a_sig <= '0'; b_sig <= '0'; c_sig <= '1'; d_sig <= '0';
    	wait for 10 ns;
    	assert(f_sig='1') report "Circuit failed for abcd=0010" severity warning;
    	
        a_sig <= '0'; b_sig <= '0'; c_sig <= '1'; d_sig <= '1';
    	wait for 10 ns;
    	assert(f_sig='1') report "Circuit failed for abcd=0011" severity warning;
            
    	a_sig <= '0'; b_sig <= '1'; c_sig <= '0'; d_sig <= '0';
    	wait for 10 ns;
    	assert(f_sig='0') report "Circuit failed for abcd=0100" severity warning;
 
	a_sig <= '0'; b_sig <= '1'; c_sig <= '0'; d_sig <= '1';
    	wait for 10 ns;
    	assert(f_sig='1') report "Circuit failed for abcd=0101" severity warning;
    	
        a_sig <= '0'; b_sig <= '1'; c_sig <= '1'; d_sig <= '0';
    	wait for 10 ns;
    	assert(f_sig='0') report "Circuit failed for abcd=0110" severity warning;
    	
        a_sig <= '0'; b_sig <= '1'; c_sig <= '1'; d_sig <= '1';
    	wait for 10 ns;
    	assert(f_sig='1') report "Circuit failed for abcd=0111" severity warning;

    	a_sig <= '1'; b_sig <= '0'; c_sig <= '0'; d_sig <= '0';
    	wait for 10 ns;
    	assert(f_sig='0') report "Circuit failed for abcd=1000" severity warning;
 
	a_sig <= '1'; b_sig <= '0'; c_sig <= '0'; d_sig <= '1';
    	wait for 10 ns;
    	assert(f_sig='0') report "Circuit failed for abcd=1001" severity warning;
    	
        a_sig <= '1'; b_sig <= '0'; c_sig <= '1'; d_sig <= '0';
    	wait for 10 ns;
    	assert(f_sig='0') report "Circuit failed for abcd=1010" severity warning;
    	
        a_sig <= '1'; b_sig <= '0'; c_sig <= '1'; d_sig <= '1';
    	wait for 10 ns;
    	assert(f_sig='1') report "Circuit failed for abcd=1011" severity warning;
            
    	a_sig <= '1'; b_sig <= '1'; c_sig <= '0'; d_sig <= '0';
    	wait for 10 ns;
    	assert(f_sig='0') report "Circuit failed for abcd=1100" severity warning;
 
 		a_sig <= '1'; b_sig <= '1'; c_sig <= '0'; d_sig <= '1';
    	wait for 10 ns;
    	assert(f_sig='1') report "Circuit failed for abcd=1101" severity warning;
    	
        a_sig <= '1'; b_sig <= '1'; c_sig <= '1'; d_sig <= '0';
    	wait for 10 ns;
    	assert(f_sig='0') report "Circuit failed for abcd=1110" severity warning;
    	
        a_sig <= '1'; b_sig <= '1'; c_sig <= '1'; d_sig <= '1';
    	wait for 10 ns;
    	assert(f_sig='0') report "Circuit failed for abcd=1111" severity warning;

        assert false report "Simulation Terminated" severity failure;
end process;
end architecture basic_testbench;
