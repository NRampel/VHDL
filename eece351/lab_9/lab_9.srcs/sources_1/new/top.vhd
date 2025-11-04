library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity top is
   port ( 
       btnC, btnL, btnU, btnD, clk : in std_logic; 
       sw : in std_logic_vector(7 downto 0); 
       an : out std_logic_vector(3 downto 0); 
       seg : out std_logic_vector(6 downto 0); 
       dp : out std_logic
   );
end top;

architecture Behavioral of top is
    component debouncer is 
        port(
            a, clk : in std_logic; 
            q : out std_logic
        ); 
    end component; 
    
    component pulser is 
        port( 
            a, clk : in std_logic; 
            a_pulse : out std_logic
        ); 
     end component; 
     
     component synchronizer is 
        generic(
            depth : positive := 2
        ); 
        port(
            a, clk : in std_logic; 
            a_sync : out std_logic
        ); 
      end component; 
      
      component vending_machine is 
        port(
            vend0, vend1, vend2, vend3 : in std_logic; 
            vend4, vend5, vend6, vend7 : in std_logic;
            clk, rst : in std_logic; 
            refund, quarter, dollar : in std_logic; 
            display : out std_logic_vector(27 downto 0)   
        ); 
      end component; 
      
      component SSEG_Driver is 
        port(
            vend_data : in std_logic_vector(27 downto 0); 
            clk : in std_logic; 
            anode : out std_logic_vector(3 downto 0); 
            segment : out std_logic_vector(6 downto 0); 
            dp : out std_logic
        ); 
       end component; 
      
      signal rst_sync : std_logic; 
      signal vend_sync : std_logic_vector(7 downto 0); 
      signal vend_deb : std_logic_vector(7 downto 0); 
      signal vend_pulsed : std_logic_vector(7 downto 0); 
      signal qrtr_sync : std_logic; 
      signal qrtr_deb : std_logic; 
      signal qrtr_pulsed : std_logic; 
      signal dlr_sync : std_logic; 
      signal dlr_deb : std_logic; 
      signal dlr_pulsed : std_logic; 
      signal rfnd_sync : std_logic; 
      signal rfnd_deb : std_logic; 
      signal rfnd_pulsed : std_logic; 
      signal sseg_disp : std_logic_vector(27 downto 0); 
begin
    Sync_Rst : synchronizer port map(a=>btnC, clk=>clk, a_sync=>rst_sync); 
    
    Synchronizer_Qrtr : synchronizer port map(a=> btnU, clk=>clk, a_sync=>qrtr_sync); 
    Debouncer_Qtr : debouncer port map(a=>qrtr_sync, clk=>clk, q=>qrtr_deb); 
    Pulser_Qtr : pulser port map(a=>qrtr_deb, clk=>clk, a_pulse=>qrtr_pulsed); 
    
    Synchronizer_Dlr : synchronizer port map(a=>btnD, clk=>clk, a_sync=>dlr_sync); 
    Debouncer_Dlr : debouncer port map(a=>dlr_sync, clk=>clk, q=>dlr_deb); 
    Pulser_Dlr : pulser port map(a=>dlr_deb, clk=>clk, a_pulse=>dlr_pulsed); 
    
    Synchronizer_Ref : synchronizer port map(a=>btnL, clk=>clk, a_sync=>rfnd_sync); 
    Debouncer_Ref : debouncer port map(a=>rfnd_sync, clk=>clk, q=>rfnd_deb); 
    Pulser_Ref : pulser port map(a=>rfnd_deb, clk=>clk, a_pulse=>rfnd_pulsed); 
    
    processing_chain : for index in 7 downto 0 generate 
        Synchronizer_vend : synchronizer port map(a=>sw(index), clk=>clk, a_sync=>vend_sync(index)); 
        Debouncer_vend : debouncer port map(a=>vend_sync(index), clk=>clk, q=>vend_deb(index)); 
        Pulser_vend : pulser port map(a=>vend_deb(index), clk=>clk, a_pulse=>vend_pulsed(index)); 
    end generate processing_chain; 
    
    --could've used a shift register and bit concatenation instead of a for-generate loop, it would be a more behavioral alternative
    
    
    Vending_Actual : vending_machine port map(
        vend0=>vend_pulsed(0), 
        vend1=>vend_pulsed(1), 
        vend2=>vend_pulsed(2), 
        vend3=>vend_pulsed(3), 
        vend4=>vend_pulsed(4), 
        vend5=>vend_pulsed(5), 
        vend6=>vend_pulsed(6),
        vend7=>vend_pulsed(7), 
        clk=>clk,
        rst=>rst_sync, 
        refund=>rfnd_pulsed,
        quarter=>qrtr_pulsed,
        dollar=>dlr_pulsed, 
        display=>sseg_disp
    ); 
    
    Display_Driver : SSEG_Driver port map(
        vend_data=>sseg_disp, 
        clk=>clk, 
        anode=>an,
        dp=>dp,       
        segment=>seg         
    );

end Behavioral;
