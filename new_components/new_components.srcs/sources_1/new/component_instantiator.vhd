--NOTE: INCOMPLETE, DOESN'T WORK YET!!!!!!!!!!!!!!

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity component_instantiator is
    port ( 
        fp_inp, clk, rst : in std_logic; 
        fp_out : out std_logic
    );
end component_instantiator;
   
architecture Behavioral of component_instantiator is
     signal in_sync, in_deb, in_pulsed, rst_sig, in_reg, out_reg : std_logic; 
     component debouncer_new is 
         generic(
            timer : integer := 1000000
        ); 
        port(
            a_in, clk, rst : std_logic; 
            q : out std_logic
        ); 
     end component; 
     
      component pulser_new is 
        port(
            a_in, clk : std_logic; 
            q : out std_logic
        ); 
     end component; 
     
      component synchronizer_new is 
        generic(
            depth : integer := 2
        ); 
        port(
            a_in, clk, rst : std_logic; 
            q : out std_logic
        ); 
     end component; 

begin
    Syb : synchronizer_new port map(clk=>clk, rst=>rst_sig, 
    Deb : debouncer_new port map(clk=>clk, a_in=
    

end Behavioral;
