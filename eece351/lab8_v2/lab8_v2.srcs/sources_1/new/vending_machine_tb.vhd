library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD_UNSIGNED.ALL;

entity vending_machine_tb is
end vending_machine_tb;

architecture Behavioral of vending_machine_tb is
    signal vend0_sig, vend1_sig, vend2_sig, vend3_sig: std_logic;
    signal vend4_sig, vend5_sig, vend6_sig, vend7_sig: std_logic;
    signal refund_sig, quarter_sig, dollar_sig: std_logic;
    signal clk, reset: std_logic;
    signal display_sig: std_logic_vector(27 downto 0);
    
     type display_t is array(0 to 23) of std_logic_vector(27 downto 0);
    constant display_lut: display_t := (
        28x"FF02040", 28x"FF01212", 28x"FF00940", 28x"FF03C12",
        28x"FFE6040", 28x"FFE9212", 28x"FFE4940", 28x"FFE7C12",
        28x"FE92040", 28x"FE91212", 28x"FE90940", 28x"FE93C12",
        28x"FEC2040", 28x"FEC1212", 28x"FEC0940", 28x"FEC3C12",
        28x"FE66040", 28x"FE65212", 28x"FE64940", 28x"FE67C12",
        28x"FE4A040", 28x"5E395A1", 28x"2422386", 28x"0CBD7FF"
    );
  
    type test_vector_t is array (natural range <>) of std_logic_vector(16 downto 0);
    constant test_vector: test_vector_t :=(
        --R r q d 7vvvvvv0 credit
        --TV0
        b"1_0_0_0_00000000_00000", --RESET_R_Q_D_VEND7TO0_DISPL"
        b"0_0_0_0_00000000_00000",
        b"0_0_1_0_00000000_00001", --Q
        b"0_0_1_0_00000000_00010", --Q
        b"0_0_1_0_00000000_00011", --Q
        b"0_0_1_0_00000000_00100", --Q
        b"0_0_0_0_00000000_00100", 
        b"0_1_0_0_00000000_10101", --refund
        b"1_0_0_0_00000000_00000", --reset
        b"0_0_0_0_00000000_00000",
        --TV10
        b"0_0_0_1_00000000_00100", --d
        b"0_0_0_1_00000000_01000", --d
        b"0_0_0_1_00000000_01100", --d
        b"0_0_1_0_00000000_01101", --q
        b"0_0_1_0_00000000_01110", --q
        b"0_0_1_0_00000000_01111", --q
        b"0_0_0_0_00000000_01111",
        b"0_0_0_0_00000100_10111", --vend $5 (err)
        b"1_0_0_0_00000000_00000", --reset
        b"0_0_0_0_00000000_00000",
        --TV20
        b"0_0_0_1_00000000_00100", --d
        b"0_0_0_1_00000000_01000", --d
        b"0_0_0_1_00000000_01100", --d
        b"0_0_1_0_00000000_01101", --q
        b"0_0_1_0_00000000_01110", --q
        b"0_0_1_0_00000000_01111", --q
        b"0_0_1_0_00000000_10000", --q
        b"0_0_0_1_00000000_10100", --d
        b"0_0_0_0_00000100_10110", --vend $5 (sale)
        b"1_0_0_0_00000000_00000", --reset        
        --TV30
        b"0_0_0_0_00000000_00000",        
        b"0_0_1_0_00000000_00001", --q       
        b"0_0_1_0_00000000_00010", --q 
        b"0_0_0_0_00000001_10110", --vend0
        b"1_0_0_0_00000000_00000", --reset       
        b"0_0_0_0_00000000_00000",        
        b"0_0_0_1_00000000_00100", --d      
        b"0_0_0_0_00000010_10110", --vend1
        b"1_0_0_0_00000000_00000", --reset       
        b"0_0_0_0_00000000_00000",        
        --TV40
        b"0_0_0_1_00000000_00100", --d      
        b"0_0_0_1_00000000_01000", --d      
        b"0_0_1_0_00000000_01001", --q      
        b"0_0_0_0_00001000_10110", --vend3
        b"1_0_0_0_00000000_00000", --reset       
        b"0_0_0_0_00000000_00000",        
        b"0_0_0_1_00000000_00100", --d      
        b"0_0_0_1_00000000_01000", --d      
        b"0_0_0_0_00010000_10110", --vend4  
        b"1_0_0_0_00000000_00000", --reset       
        --TV50
        b"0_0_0_0_00000000_00000",        
        b"0_0_0_1_00000000_00100", --d      
        b"0_0_0_1_00000000_01000", --d      
        b"0_0_0_1_00000000_01100", --d      
        b"0_0_0_0_00100000_10110", --vend5  
        b"1_0_0_0_00000000_00000", --reset       
        b"0_0_0_0_00000000_00000",        
        b"0_0_0_1_00000000_00100", --d      
        b"0_0_0_1_00000000_01000", --d      
        --TV60
        b"0_0_0_1_00000000_01100", --d      
        b"0_0_0_1_00000000_10000", --d      
        b"0_0_0_1_00000000_10100", --d      
        b"0_0_0_0_01000000_10110", --vend6
        b"1_0_0_0_00000000_00000", --reset       
        b"0_0_0_0_00000000_00000",        
        b"0_0_0_1_00000000_00100", --d      
        b"0_0_0_1_00000000_01000", --d      
        b"0_0_0_1_00000000_01100", --d      
        b"0_0_0_1_00000000_10000", --d      
        --TV70
        b"0_0_0_1_00000000_10100", --d      
        b"0_0_0_0_10000000_10110" --vend7

    );
    component vending_machine is
      Port ( 
        vend0, vend1, vend2, vend3, vend4, vend5, vend6, vend7: in std_logic;
        refund, quarter, dollar: in std_logic;
        clk, rst: in std_logic;
        display: out std_logic_vector(27 downto 0)
      );
    end component vending_machine;
    
    signal display: std_logic_vector(4 downto 0);
    signal display_value: std_logic_vector(27 downto 0);
    
begin

UUT: vending_machine port map(
    clk => clk,
    rst => reset,
    vend0=>vend0_sig, 
    vend1=>vend1_sig, 
    vend2=>vend2_sig, 
    vend3=>vend3_sig,
    vend4=>vend4_sig, 
    vend5=>vend5_sig, 
    vend6=>vend6_sig, 
    vend7=>vend7_sig,
    refund=>refund_sig,
    quarter=>quarter_sig,
    dollar=>dollar_sig,
    display=>display_sig 
);

CLK_PROCESS: process begin
        clk <= '0';
        wait for 5ns;
        clk <= '1';
        wait for 5ns;
end process;

display_value <= display_lut(to_integer(display));

MAIN_TB: process begin
    for i in 0 to test_vector'LENGTH -1 loop
        --slice the test vector
        (reset, refund_sig, quarter_sig, dollar_sig,
         vend7_sig, vend6_sig, vend5_sig, vend4_sig, vend3_sig, vend2_sig, vend1_sig, vend0_sig,
         display) <= test_vector(i);
         --clock the FSM
         wait until rising_edge(clk);
         wait until falling_edge(clk);
         --check output
         if NOT reset then
             assert display_value = display_sig 
                report "FSM failed for test vector " & integer'IMAGE(i)
                severity failure;
         end if;
    end loop; 
    assert false report "FSM Passed the Testbench" severity failure;
end process;

end Behavioral;
