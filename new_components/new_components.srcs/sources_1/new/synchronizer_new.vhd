library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 

entity synchronizer_new is 
    generic(
        depth : integer := 2
    ); 
    port( 
        a_in, clk, rst : in std_logic;  
        a_sync : out std_logic 
    ); 
end synchronizer_new; 

architecture behavioral of synchronizer_new is
    signal shift_reg : std_logic_vector(depth-1 downto 0); 
    attribute ASYNC_REG : string;
    attribute ASYNC_REG of shift_reg : signal is "TRUE";
begin 
    process(clk) begin 
        if rst = '1' then 
            shift_reg <= (others=>'0'); 
        elsif rising_edge(clk) then 
            shift_reg <= shift_reg(depth-2 downto 0) & a_in; 
        end if; 
    end process; 
    a_sync <= shift_reg(depth-1); 
end behavioral;