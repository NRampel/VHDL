library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port(
        sw : in std_logic_vector(15 downto 0); 
        seg : out std_logic_vector(6 downto 0); 
        an : out std_logic_vector(3 downto 0); 
        dp : out std_logic
      );   
end top;

architecture Behavioral of top is
   component bcd_to_seven is 
    port(
        sw_in : in std_logic_vector(3 downto 0);   
        dec_out : out std_logic_vector(6 downto 0) 
    );
    end component;  
    
    component hex_to_seven is
    port(
        sw_in : in std_logic_vector(3 downto 0); 
        dec_out : out std_logic_vector(6 downto 0)
    ); 
    end component; 
    
    signal out_bcd, out_hex : std_logic_vector(6 downto 0); 
begin
    bcd_1: bcd_to_seven port map(
        sw_in  => sw(3 downto 0), 
        dec_out => out_bcd
        );  
    hex_1: hex_to_seven port map(
        sw_in => sw(3 downto 0), 
        dec_out => out_hex
        ); 

seg <= out_bcd when sw(8) = '1' else out_hex; 

dp <= sw(4); 
an(3 downto 0) <= sw(15 downto 12); 

  
end Behavioral;
