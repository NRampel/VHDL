library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL; 

entity debouncer is 
port( 
    a : in std_logic;
    clk : in std_logic; 
    q : out std_logic
    ); 
end debouncer; 

architecture Behavioral of debouncer is 
    constant MAX : integer :=1000000; 
    
    signal s1, s2 : std_logic := '0'; 
    signal counter : integer range 0 to MAX := 0;  
    signal q_reg : std_logic := '0'; 
begin
    process(clk) begin 
        if rising_edge(clk) then 
            s1 <= a; 
            s2 <= s1; 
            if s1 /= s2 then 
                counter <= 0; 
            elsif counter < MAX then 
                counter <= counter + 1; 
            else 
                q_reg <= s2; 
            end if;
        end if; 
   end process; 
   q <= q_reg; 
end Behavioral; 