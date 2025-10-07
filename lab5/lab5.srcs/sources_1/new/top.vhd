library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEe.NUMERIC_STD.ALL; 

entity top is
port (
    btnr : in std_logic; 
    sw : in std_logic_vector(7 downto 0); 
    led : out std_logic_vector(4 downto 0) 
     );
end top;

architecture Behavioral of top is
    component debouncer is
        port (
            a : in std_logic; 
            clk : in std_logic; 
            q : out std_logic
            ); 
    end component; 
    component pulser is
        port (
            a : in std_logic; 
            clk : in std_logic; 
            a_pulse : out std_logic
            ); 
    end component; 
    component detect_11010 is 
        port (
            clk : in std_logic; 
            rst : in std_logic; 
            en : in std_logic; 
            a : in std_logic;
            f : out std_logic_vector(3 downto 0)
            ); 
    end component; 
            
    signal btn_in, btn_db, btn_pulse : std_logic;   
    signal rs_in : std_logic_vector(1 downto 0); 
    signal 
begin
    --proces(clk) begin 
    

end Behavioral;
