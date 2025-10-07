----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/06/2025 01:59:12 PM
-- Design Name: 
-- Module Name: pulser - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pulser is
port (
    a : in std_logic; 
    clk : in std_logic; 
    a_pulse : out std_logic
    );
end pulser;

architecture Behavioral of pulser is
    signal a_reg : std_logic := '0';    
begin
    process(clk) begin
        if rising_edge(clk) then
            a_reg <= a; 
        end if; 
    end process; 

end Behavioral;
