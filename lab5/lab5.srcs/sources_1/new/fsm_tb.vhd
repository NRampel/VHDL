library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_tb is
end fsm_tb;

architecture Behavioral of fsm_tb is

component fsm is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           a : in STD_LOGIC;
           f : out STD_LOGIC);
end component fsm;
--test vector format is a_f
type test_vector_t is array (natural range<>) of std_logic_vector( 1 downto 0);
constant test_vector: test_vector_t :=
(
    b"0_0", --S0 Self Arc
    b"1_0", --S0 to S1
    b"0_1", --S1 to S2
    b"0_1", --S2 to S2
    b"1_0", --S2 to S0
    b"1_0", --S0 to S1
    b"1_1", --S1 to S3
    b"0_0", --S3 to S2
    b"1_0", --S2 to S0
    b"1_0", --S0 to S1
    b"1_1", --S1 to S3
    b"1_0"  --S3 to S2
    
);
signal clk, reset_sig, a_sig, f_sig: std_logic;

begin

UUT: fsm port map( clk=>clk, reset=>reset_sig, a=>a_sig, f=>f_sig);

RST_CLK: process begin
    reset_sig <= '1';
    loop
        clk <= '0';
        wait for 5ns;
        clk <= '1';
        wait for 5ns;
        reset_sig <= '0';
    end loop;
end process;

MAIN_TB: process begin
    for i in 0 to test_vector'LENGTH -1 loop
        wait until falling_edge(clk);
        a_sig <= test_vector(i)(1);
        wait until rising_edge(clk);
        assert f_sig = test_vector(i)(0)
            report "FSM failed for test vector " & integer'IMAGE(i)
            severity failure;
    end loop; 
    assert false report "FSM Passed the Testbench" severity failure;
end process;

end Behavioral;
