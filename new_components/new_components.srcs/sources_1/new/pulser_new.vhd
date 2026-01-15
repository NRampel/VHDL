library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;  

entity pulser_new is 
    port( 
        a_in, rst, clk : in std_logic; 
        a_out : out std_logic
    ); 
end pulser_new; 

architecture behavioral of pulser_new is
    signal a_reg : std_logic := '0';  
begin 
    process(clk) begin
        if rising_edge(clk) then 
            if rst='1' then 
                a_reg <= '0'; 
            else 
                a_reg <= a_in;
            end if; 
        end if; 
    end process;    
    a_out <= a_in and (not a_reg) and (not rst); 
            
end behavioral; 