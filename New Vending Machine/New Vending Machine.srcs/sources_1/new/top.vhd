library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL; 

entity top is 
    port(
        btnU, btnD, btnL, btnR, btnC : in std_logic; 
        clk, rst : in std_logic; 
        seg : out std_logic_vector(6 downto 0); 
        sw : in std_logic_vector(7 downto 0); 
        dp : out std_logic; 
        an : out std_logic_vector(3 downto 0)
    ); 
end top; 

architecture Behavioral of top is 
    component debouncer_new is 
        generic(
            timer : integer := 1000000 
        ); 
        port( 
            a_in, clk, rst : in std_logic;  
            q : out std_logic 
        ); 
    end component; 
    
    component synchronizer_new is 
         generic(
            depth : integer := 2
         ); 
         port( 
            a_in, clk, rst : in std_logic;  
            a_sync : out std_logic 
         ); 
    end component; 
    
    component pulser_new is 
        port(
            a_in, rst, clk : in std_logic; 
            a_out : out std_logic 
        ); 
    end component; 

    component Vend_SSEG_Driver is 
        generic(
            clk_cy : integer := 100000
        ); 
        port ( 
            clk, rst : in std_logic; 
            vend_data : in std_logic_vector(27 downto 0);
            seg : out std_logic_vector(6 downto 0); 
            dp : out std_logic; 
            an : out std_logic_vector(3 downto 0)
         );
    end component;

    component vending_machine is 
        port ( 
            vend : in std_logic_vector(7 downto 0); 
            clk, rst, refund, quarter, dollar : in std_logic; 
            display : out std_logic_vector(27 downto 0); 
            vend_out : out std_logic
        );    
    end component;
    
      signal rst_sync : std_logic; 
      signal vend_reg : std_logic_vector(7 downto 0); 
      signal qrtr_sync, qrtr_deb, qrtr_pulsed : std_logic; 
      signal dlr_sync, dlr_deb, dlr_pulsed : std_logic; 
      signal rfnd_sync, rfnd_deb, rfnd_pulsed : std_logic; 
      signal shift_sync, shift_deb, shift_pulsed : std_logic; 
      signal sseg_disp : std_logic_vector(27 downto 0); 
      signal ack_clear : std_logic; 
  
begin 
    Sync_rst : synchronizer_new port map (a_in => btnC, clk => clk, rst => '0', a_sync => rst_sync);
    
    Sync_qtr : synchronizer_new port map (a_in => btnD, clk => clk, rst => rst_sync, a_sync => qrtr_sync);
    Debounce_qtr : debouncer_new port map (a_in => qrtr_sync, clk => clk, rst => rst_sync, q => qrtr_deb);
    Pulse_qtr : pulser_new port map (a_in => qrtr_deb, rst => rst_sync, clk => clk, a_out => qrtr_pulsed);
    
    Sync_dlr : synchronizer_new port map (a_in => btnL, clk => clk, rst => rst_sync, a_sync => dlr_sync);
    Debounce_dlr : debouncer_new port map (a_in => dlr_sync, clk => clk, rst => rst_sync, q => dlr_deb);
    Pulse_dlr : pulser_new port map (a_in => dlr_deb, rst => rst_sync, clk => clk, a_out => dlr_pulsed);
    
    Sync_rfnd : synchronizer_new port map (a_in => btnR, clk => clk, rst => rst_sync, a_sync => rfnd_sync);
    Debounce_rfnd : debouncer_new port map (a_in => rfnd_sync, clk => clk, rst => rst_sync, q => rfnd_deb);
    Pulse_rfnd : pulser_new port map (a_in => rfnd_deb, rst => rst_sync, clk => clk, a_out => rfnd_pulsed);
    
    Sync_shift : synchronizer_new port map(a_in => btnU, clk=>clk, rst=>rst_sync, a_sync=>shift_sync); 
    Debounce_shift : debouncer_new port map(a_in=>shift_sync, clk=>clk, rst=>rst_sync, q=>shift_deb); 
    Pulse_shift : pulser_new port map(a_in=>shift_deb, clk=>clk, rst=>rst_sync, a_out=>shift_pulsed); 
    
    process(clk) begin
        if rising_edge(clk) then
            if rst_sync = '1' then
                vend_reg <= (others => '0');
            elsif ack_clear = '1' then 
                vend_reg <= (others=>'0'); 
            elsif shift_pulsed = '1' then
                vend_reg <= vend_reg(6 downto 0) & sw(0); 
            end if;
        end if;
    end process;

    Vend_inst : vending_machine port map (
        vend => vend_reg, 
        clk => clk, 
        rst => rst_sync, 
        refund => rfnd_pulsed, 
        quarter => qrtr_pulsed, 
        dollar => dlr_pulsed, 
        display => sseg_disp,
        vend_out => ack_clear
    );
    
    Vend_SSEG_Driver_inst : Vend_SSEG_Driver port map (
        clk => clk, 
        rst => rst_sync, 
        vend_data => sseg_disp, 
        seg => seg, 
        dp => dp, 
        an => an
    );
    
end Behavioral; 
