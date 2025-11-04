library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity synchronizer is
    generic(
        depth : positive := 2
    ); 
    port( 
        clk : in std_logic; 
        a : in std_logic; 
        a_sync : out std_logic
    );
end synchronizer;

architecture Behavioral of synchronizer is
    signal shift_reg : std_logic_vector(1 to depth);  
begin
    process(clk) begin 
        if rising_edge(clk) then 
            shift_reg <= a & shift_reg(1 to depth - 1); 
        end if; 
    end process; 
    a_sync <= shift_reg(depth); 
end Behavioral;
