library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- 11010 = 26 in base 10

entity detect_11010 is
port ( 
    clk : in std_logic; 
    rst : in std_logic; 
    en : in std_logic; 
    a : in std_logic; 
    f : out std_logic 
    );
end detect_11010;

architecture Behavioral of detect_11010 is
    type state_type is (S0, S1, S2, S3, S4); 
    signal current_state, next_state : state_type; 
begin
    process(clk) begin
        if rising_edge(clk) then 
            if rst then
                current_state <=S0; 
            elsif en then 
                current_state <= next_state; 
            end if;
        end if; 
    end process; 
    
    process(current_state, a) begin 
        f <= '0'; 
        next_state <= current_state; 
        case current_state is
        when S0 => 
            if a = '1' then 
                next_state <= S1; 
            else
                next_state <= S0; 
            end if; 
        
        when S1 =>
            if a = '1' then
                next_state <= S2; 
            else 
                next_state <= S0; 
            end if; 
       
        when S2 => 
            if a = '0' then 
                next_state <= S3; 
            end if; 
      
        when S3 => 
            if a = '0' then 
                next_state <= S0; 
            else 
                next_state <= S4; 
            end if; 
     
        when S4 => 
            if a = '1' then 
                next_state <= S2; 
            else 
                f <= '1'; 
                next_state <= S0; 
            end if; 
        end case; 
     end process;          
            

end Behavioral;
