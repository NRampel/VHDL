
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity top is
    port(
        btnR, clk : in std_logic; 
        sw : in std_logic_vector(3 downto 0); 
        led : out std_logic_vector(1 downto 0)
    );         
end top;

architecture Behavioral of top is
    component detect_11010 is 
        port (
            clk, a, rst, en : in std_logic; 
            f : out std_logic
        ); 
    end component detect_11010; 
    
    component debouncer is 
        port ( 
            a, clk : in std_logic; 
            q : out std_logic
        ); 
    end component debouncer; 
    
    component pulser is 
        port ( 
            a, clk : in std_logic; 
            a_pulse : out std_logic
        ); 
    end component pulser; 
    
    signal btn_db, btn_plse, fsm_output: std_logic; 
    signal led_latch : std_logic := '0'; 
begin
     debounce_unit : debouncer port map(clk=>clk, a=>btnR, q=>btn_db); 
     pulse_unit : pulser port map(clk=>clk, a=>btn_db, a_pulse=>btn_plse); 
     fsm_implementation : detect_11010 port map(clk=>clk, rst=>sw(1), a=>sw(0), en=>btn_plse, f=>fsm_output); 
    process(clk)
    begin
        if rising_edge(clk) then
            if fsm_output = '1' then
                led_latch <= '1';
            elsif sw(1) = '1' then
                led_latch <= '0';
            end if;
        end if;
    end process;

    led(0) <= led_latch;
    led(1) <= '0'; 
end Behavioral;
