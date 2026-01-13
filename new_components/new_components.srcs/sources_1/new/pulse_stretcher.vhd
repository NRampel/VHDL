library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity pulse_stretcher is
    generic(
        stretch_cycles : integer := 4
    ); 
     port ( 
        a_in, rst, clk : in std_logic; 
        a_out : out std_logic     
     );
end pulse_stretcher;

architecture Behavioral of pulse_stretcher is
    signal chain_reg : std_logic_vector(stretch_cycles-1 downto 0); 
begin
    process(clk, rst) begin
        if rst='1' then 
            chain_reg <= (others=>'0'); 
        elsif rising_edge(clk) then 
            chain_reg <= chain_reg(stretch_cycles-2 downto 0) & a_in; 
        end if; 
    end process; 
    process(clk) begin 
        if rising_edge(clk) then
            if (unsigned(chain_reg) > 0 OR a_in = '1') then 
                a_out <= '1'; 
            else
                a_out <= '0'; 
            end if; 
       end if; 
    end process; 
end Behavioral;
