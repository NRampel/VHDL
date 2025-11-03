library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity SSEG_Driver is
    port (
        vend_data : in std_logic_vector(27 downto 0); 
        clk : in std_logic; 
        anode : out std_logic_vector(3 downto 0); 
        segment : out std_logic_vector(6 downto 0);  
        dp : out std_logic
    ); 
end SSEG_Driver;

architecture Behavioral of SSEG_Driver is
    constant CLOCK_CY : integer := 99_999; 
   -- constant dp_const : integer := 4; 
    signal clk_div : integer range 0 to CLOCK_CY; 
    signal decimal_point : std_logic; 
    signal anode_counter : std_logic_vector(1 downto 0) := "00"; 
    signal anode_register : std_logic_vector(3 downto 0) := "1111"; 
    signal sseg_register : std_logic_vector(6 downto 0) := "1111111";  
    signal dp_register : std_logic := '1'; 
   

begin

    with vend_data select
        decimal_point <= 
            '1' when 28x"5E395A1",
            '1' when 28x"2422386", 
            '1' when 28x"0CBD7FF", 
            '0' when others;
    process(clk) begin
        if rising_edge(clk) then 
            if clk_div = CLOCK_CY then    
                clk_div <= 0; 
                anode_counter <= std_logic_vector(unsigned(anode_counter) + 1); 
                case anode_counter is
                    when "00" =>
                        anode_register <= "1110"; 
                        sseg_register <= vend_data(6 downto 0); 
                        dp_register <= '1';   
                    when "01" =>
                        anode_register <= "1101"; 
                        sseg_register <= vend_data(13 downto 7); 
                        dp_register <= '1'; 
                    when "10" =>
                        anode_register <= "1011"; 
                        sseg_register <= vend_data(20 downto 14);  
                        if (decimal_point='0') then 
                            dp_register <= '0'; 
                        else 
                            dp_register <= '1'; 
                        end if; 
                    when "11" =>
                        anode_register <= "0111"; 
                        sseg_register <= vend_data(27 downto 21);   
                        dp_register <= '1';                     
                    when others =>
                        anode_register <= "1111"; 
                        sseg_register <= "1111111";   
                        dp_register <= '1'; 
                end case;
             else
                clk_div <= clk_div + 1;
             end if;
        end if;
    end process;
 
    anode  <= anode_register;
    segment <= sseg_register;
    dp <= dp_register; 
    
end Behavioral;
