library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 


entity sqrt8i_tb is 
end sqrt8i_tb; 

architecture testing of sqrt8i_tb is 

signal start_sig, done_sig : std_logic; 
signal clk : std_logic := '0'; 
signal reset_sig : std_logic := '1'; 
signal a_sig : std_logic_vector(7 downto 0); 
signal sqrt_sig : unsigned(3 downto 0); 

component sqrt8i is 
    port(
        a : in std_logic_vector(7 downto 0); 
        clk, rst, start : in std_logic; 
        done : out std_logic; 
        sqrt : out unsigned(3 downto 0)
   ); 
end component sqrt8i; 

  constant CLK_PERIOD : time := 10 ns;  
  
begin 

UUF: sqrt8i port map(clk=>clk, 
                    a=>a_sig, 
                    done=>done_sig, 
                    start=>start_sig, 
                    rst=>reset_sig, 
                    sqrt=>sqrt_sig); 

process begin 
    loop
        clk <= '0'; 
        wait for CLK_PERIOD / 2; 
        clk <= '1'; 
        wait for CLK_PERIOD / 2; 
    end loop; 
end process; 

MAIN_TB: process begin
     
        report "Starting Reset" severity note;
        reset_sig <= '1';
        start_sig <= '0';
        a_sig     <= (others => '0');
        wait for CLK_PERIOD * 3;
        reset_sig <= '0';
        wait until falling_edge(clk);
        report "Reset finished. Starting Test Sequence (A = 0, 1, 100, 101, 225, 255)." severity note;
        
        --a=0
        a_sig <= std_logic_vector(to_unsigned(0, 8));
        wait until falling_edge(clk);
        start_sig <= '1';
        wait until falling_edge(clk);
        start_sig <= '0';
        a_sig <= (others => '0');
        wait until done_sig='1' and rising_edge(clk);
        assert (sqrt_sig = to_unsigned(0, 4)) report "Test FAILED for A=0. Expected 0, got " & integer'image(to_integer(sqrt_sig)) severity error;
        report "Test A=0 PASSED. Sqrt=" & integer'image(to_integer(sqrt_sig)) severity note;
        wait until rising_edge(clk);

        --a=1
        a_sig <= std_logic_vector(to_unsigned(1, 8));
        wait until falling_edge(clk);
        start_sig <= '1';
        wait until falling_edge(clk);
        start_sig <= '0';
        a_sig <= (others => '0');
        wait until done_sig='1' and rising_edge(clk);
        assert (sqrt_sig = to_unsigned(1, 4)) report "Test FAILED for A=1. Expected 1, got " & integer'image(to_integer(sqrt_sig)) severity error;
        report "Test A=1 PASSED. Sqrt=" & integer'image(to_integer(sqrt_sig)) severity note;
        wait until rising_edge(clk);

   
        --a=100
        a_sig <= std_logic_vector(to_unsigned(100, 8));
        wait until falling_edge(clk);
        start_sig <= '1';
        wait until falling_edge(clk);
        start_sig <= '0';
        a_sig <= (others => '0');
        wait until done_sig='1' and rising_edge(clk);
        assert (sqrt_sig = to_unsigned(10, 4)) report "Test FAILED for A=100. Expected 10, got " & integer'image(to_integer(sqrt_sig)) severity error;
        report "Test A=100 PASSED. Sqrt=" & integer'image(to_integer(sqrt_sig)) severity note;
        wait until rising_edge(clk);
        
        --a=101
        a_sig <= std_logic_vector(to_unsigned(101, 8));
        wait until falling_edge(clk);
        start_sig <= '1';
        wait until falling_edge(clk);
        start_sig <= '0';
        a_sig <= (others => '0');
        wait until done_sig='1' and rising_edge(clk);
        assert (sqrt_sig = to_unsigned(10, 4)) report "Test FAILED for A=101. Expected 10, got " & integer'image(to_integer(sqrt_sig)) severity error;
        report "Test A=101 PASSED. Sqrt=" & integer'image(to_integer(sqrt_sig)) severity note;
        wait until rising_edge(clk);

        --a=225
        a_sig <= std_logic_vector(to_unsigned(225, 8));
        wait until falling_edge(clk);
        start_sig <= '1';
        wait until falling_edge(clk);
        start_sig <= '0';
        a_sig <= (others => '0');
        wait until done_sig='1' and rising_edge(clk);
        assert (sqrt_sig = to_unsigned(15, 4)) report "Test FAILED for A=225. Expected 15, got " & integer'image(to_integer(sqrt_sig)) severity error;
        report "Test A=225 PASSED. Sqrt=" & integer'image(to_integer(sqrt_sig)) severity note;
        wait until rising_edge(clk);

        --a=225
        a_sig <= std_logic_vector(to_unsigned(255, 8));
        wait until falling_edge(clk);
        start_sig <= '1';
        wait until falling_edge(clk);
        start_sig <= '0';
        a_sig <= (others => '0');
        wait until done_sig='1' and rising_edge(clk);
        assert (sqrt_sig = to_unsigned(15, 4)) report "Test FAILED for A=255. Expected 15, got " & integer'image(to_integer(sqrt_sig)) severity error;
        report "Test A=255 PASSED. Sqrt=" & integer'image(to_integer(sqrt_sig)) severity note;
        wait until rising_edge(clk);
        
       
      
        wait for CLK_PERIOD * 5;
        assert false report "FSM Passed the Testbench" severity failure;
     end process;    






end testing; 