library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity detect_11010_mealy_tb is
end detect_11010_mealy_tb;

architecture mealy_tb of detect_11010_mealy_tb is
    type test_vector_t is array (natural range<>) of std_logic_vector(1 downto 0);
    constant test_vector : test_vector_t := (
        b"1_0", -- 1.  S0 -> S1
        b"1_0", -- 2.  S1 -> S2
        b"0_0", -- 3.  S2 -> S3
        b"1_0", -- 4.  S3 -> S4
        b"0_1", -- 5.  S4 -> S0 
        b"0_0", -- 6.  S0 -> S0 
        b"1_0", -- 7.  S0 -> S1 
        b"0_0", -- 8.  S1 -> S0 
        b"1_0", -- 9.  S0 -> S1
        b"1_0", -- 10. S1 -> S2
        b"1_0", -- 11. S2 -> S2 
        b"0_0", -- 12. S2 -> S3
        b"0_0", -- 13. S3 -> S0 
        b"0_0"  -- 14. S0 -> S0 
        );
        
        signal clk, a_sig, f_sig, reset_sig : std_logic; 
begin
UUF: entity work.detect_11010_mealy(mealy_shift_register) port map (clk=>clk, rst=>reset_sig, en=>'1', a=>a_sig, f=>f_sig); 
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
            report "FSM failed for test vector" & integer'IMAGE(i) 
            severity failure; 
    end loop;
    assert false report "FSM Passed the testbench" severity note; 
    wait; 
    end process;  

end mealy_tb;



architecture moore_tb of detect_11010_mealy_tb is
    type test_vector_t is array (natural range<>) of std_logic_vector(1 downto 0);
    constant test_vector : test_vector_t := (
     b"0_0", 
     b"1_0", 
     b"0_0", 
     b"1_0", 
     b"1_0", 
     b"1_0", 
     b"0_0", 
     b"1_0", 
     b"1_0", 
     b"0_0", 
     b"0_0", 
     b"1_0", 
     b"1_0", 
     b"0_0", 
     b"1_0", 
     b"0_1", 
     b"1_0", 
     b"1_0", 
     b"0_0", 
     b"1_0", 
     b"0_1", 
     b"0_0"
        );
        
        signal clk, a_sig, f_sig, reset_sig : std_logic; 
begin 
UUF: entity work.detect_11010_mealy(moore_shift_register) port map(clk=>clk, rst=>reset_sig, en=>'1', a=>a_sig, f=>f_sig); 
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
            report "FSM failed for test vector" & integer'IMAGE(i) 
            severity failure; 
    end loop;
    assert false report "FSM Passed the testbench" severity note; 
    wait; 
    end process;  
 end moore_tb; 



