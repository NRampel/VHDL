library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Vend_SSEG_Driver_tb is
end Vend_SSEG_Driver_tb;

architecture Behavioral of Vend_SSEG_Driver_tb is
    component Vend_SSEG_Driver is
        generic(
            clk_cy : integer := 5 -- Fast clock for simulation
        ); 
        port ( 
            clk, rst : in std_logic; 
            vend_data : in std_logic_vector(27 downto 0);
            seg : out std_logic_vector(6 downto 0); 
            dp : out std_logic; 
            an : out std_logic_vector(3 downto 0)
         );
    end component;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal vend_data : std_logic_vector(27 downto 0) := (others => '0');
    signal seg : std_logic_vector(6 downto 0);
    signal dp : std_logic;
    signal an : std_logic_vector(3 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;

begin

    UUT: Vend_SSEG_Driver
        generic map (
            clk_cy => 2 -- Very fast multiplexing for TB
        )
        port map (
            clk => clk,
            rst => rst,
            vend_data => vend_data,
            seg => seg,
            dp => dp,
            an => an
        );

    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Hold reset state
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        
        -- Test 1: Display Money (Should have DP ON at digit 2)
        -- Data for e.g., 1.25 (just random segments for illustration)
        vend_data <= x"0123456"; 
        wait for 200 ns;
        
        -- Test 2: Display Text "Err" (Should have DP OFF)
        vend_data <= x"5E395A1"; 
        wait for 200 ns;
        
        -- Test 3: Display Text "End"
        vend_data <= x"0CBD7FF";
        wait for 200 ns;
        
        assert false report "Simulation Completed" severity failure;
    end process;

end Behavioral;
