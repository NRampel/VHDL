--NOTE: MUST BE INSTAMTIATED AFTER SYNHCRONIZER
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity debouncer_new is
    generic(
        timer : integer := 1000000 
    ); 
    port ( 
        a_in, clk, rst : in std_logic; 
        q : out std_logic
     );
end debouncer_new;

architecture Behavioral of debouncer_new is
    signal a_reg : std_logic; 
    signal ctr : integer range timer downto 0 := 0; 
    signal q_reg : std_logic := '0'; 
begin
    process(clk) begin 
        if rising_edge(clk) then 
            if rst='1' then 
                q_reg <= '0';
                ctr <= 0;
                a_reg <= '0';
            else 
                a_reg <= a_in; 
                if a_reg /= a_in then 
                    ctr <= timer; 
                elsif ctr > 0 then 
                    ctr <= ctr - 1; 
                else 
                    q_reg <= a_reg; 
                end if; 
            end if; 
       end if; 
     end process; 
     q <= q_reg; 
end Behavioral;
