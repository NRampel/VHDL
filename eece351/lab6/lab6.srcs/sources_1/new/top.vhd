library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    port ( clk : in std_logic;
           btnR: in std_logic;
           sw  : in std_logic_vector(15 downto 0);
           led : out std_logic_vector(15 downto 0)
    );
end top;

architecture Behavioral of top is

    signal btnr_debounced: std_logic;
    signal btnr_pulsed: std_logic;
    
    signal mealy_fsm_out: std_logic;
    signal mealy_shift_register_out: std_logic;
    signal moore_fsm_out: std_logic;
    signal mealy_fsm_with_out_registered: std_logic;
    signal mealy_fsm_with_in_registered: std_logic;

    signal a_registered: std_logic;
    
begin

    led(0) <= mealy_fsm_out;
    led(1) <= mealy_shift_register_out;
    led(2) <= moore_fsm_out;
    led(3) <= mealy_fsm_with_out_registered;
    led(4) <= mealy_fsm_with_in_registered;
    
  
    a_registered <= sw(0) when btnr_pulsed='1' and rising_edge(clk);
    mealy_fsm_with_out_registered <=  mealy_fsm_out when btnr_pulsed='1' and rising_edge(clk);
    
    U1: entity work.debouncer port map( clk=>clk, a=>btnr, q=>btnr_debounced); 
    U2: entity work.pulser port map( clk=>clk, a=>btnr_debounced, a_pulse=>btnr_pulsed);
    U3: entity work.detect_11010_new(mealy_fsm)             
        port map( clk=>clk, rst=>sw(1), a=>sw(0), en=>btnr_pulsed, f=>mealy_fsm_out);
    U4: entity work.detect_11010_new(mealy_shift_register)  
        port map( clk=>clk, rst=>sw(1), a=>sw(0), en=>btnr_pulsed, f=>mealy_shift_register_out);
    U5: entity work.detect_11010_new(moore_fsm)             
        port map( clk=>clk, rst=>sw(1), a=>sw(0), en=>btnr_pulsed, f=>moore_fsm_out);
    U6: entity work.detect_11010_new(mealy_fsm)             
        port map( clk=>clk, rst=>sw(1), a=>a_registered, en=>btnr_pulsed, f=>mealy_fsm_with_in_registered);

end Behavioral;
