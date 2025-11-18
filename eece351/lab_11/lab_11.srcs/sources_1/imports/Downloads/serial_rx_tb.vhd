----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2025 03:08:11 PM
-- Design Name: 
-- Module Name: serial_rx_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity serial_rx_tb is
--  Port ( );
end serial_rx_tb;

architecture Behavioral of serial_rx_tb is

    component top is
      Port ( 
        clk, rst: in std_logic;
        rx, tick: in std_logic;
        data: out std_logic_vector(7 downto 0);
        done: out std_logic
        );
    end component top;

    signal clk, reset, rx_sig, tick_sig, done_sig: std_logic;
    signal data_sig: std_logic_vector(7 downto 0);

begin

    UUT: top port map (
        clk   => clk,
        rst => reset,
        rx    => rx_sig,
        tick  => tick_sig,
        data  => data_sig,
        done  => done_sig
        );

    RESET_CLK: process begin
        reset <= '1';
        loop
            clk <= '0';
            wait for 1ns;
            clk <= '1';
            wait for 1ns;
            reset <= '0';
         end loop;
    end process;
    
    MAIN_TB: process begin
        rx_sig <= '1';
        tick_sig <= '0';
        
        wait until reset = '0';
        wait until falling_edge(clk);
        --check that circuit waits for tick
        assert done_sig='1' 
            report "done did not go high after reset"
            severity failure;
            
        rx_sig <= '0';
        wait until falling_edge(clk);
        --check that done is 0, indicating that we changed state
        assert done_sig='0' 
            report "done did not go to 0 after start bit detected"
            severity failure;
        --Do START bit
        rx_sig <= '0';
        tick_sig <= '1';
        for i in 1 to 16 loop
            wait until falling_edge(clk);
        end loop;
        --Do First Data Bit
        rx_sig <= '0';
        tick_sig <= '1';
        for i in 1 to 16 loop
            wait until falling_edge(clk);
        end loop;
        assert data_sig = "0UUUUUUU"
            report "Data register did not sample first bit correctly"
            severity failure;
        --Do Second Data Bit
        rx_sig <= '1';
        tick_sig <= '1';
        for i in 1 to 16 loop
            wait until falling_edge(clk);
        end loop;
        assert data_sig = "10UUUUUU"
            report "Data register did not sample second bit correctly"
            severity failure;
        --Do Remaining Data Bits
        for j in 1 to 6 loop
            rx_sig  <= NOT rx_sig;
            tick_sig <= '1';
            for i in 1 to 16 loop
                wait until falling_edge(clk);
            end loop;
        end loop;
        assert data_sig = "10101010"
                report "Data register did not sample bits correctly"
                severity failure;
        assert done_sig = '0'
                report "Done went high before stop bit transmitted"
                severity failure;
        --STOP bit
        rx_sig <= '1';
        for i in 1 to 16 loop
            wait until falling_edge(clk);
        end loop;
        assert done_sig = '1'
                report "Done did not go high after stop bit transmitted"
                severity failure;
        
        --we made it!    
        
        assert false 
            report "Testbench Completed Successfully"
            severity failure;
    end process;
end Behavioral;
