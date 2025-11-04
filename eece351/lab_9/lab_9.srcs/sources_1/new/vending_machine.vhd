library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD_unsigned.ALL; 

entity vending_machine is
    port(
        vend0, vend1, vend2, vend3 : in std_logic; 
        vend4, vend5, vend6, vend7 : in std_logic;
        clk, rst : in std_logic; 
        refund, quarter, dollar : in std_logic; 
        display : out std_logic_vector(27 downto 0)
        );  
end vending_machine;
architecture Behavioral of vending_machine is
    type state_t is (S0, S1, S2, S3, S4);
    signal state, next_state: state_t;
    --credit register
    signal credit, next_credit: std_logic_vector( 4 downto 0);
    --cntr register and control signals
    signal cntr: std_logic_vector(27 downto 0);
    signal clr_cntr, inc_cntr: std_logic;   --Not needed rn
    
      
    type display_t is array(0 to 23) of std_logic_vector(27 downto 0);
    constant display_lut: display_t := (
        28x"FF02040", 28x"FF01212", 28x"FF00940", 28x"FF03C12",
        28x"FFE6040", 28x"FFE5212", 28x"FFE4940", 28x"FFE7C12",
        28x"FE92040", 28x"FE91212", 28x"FE90940", 28x"FE93C12",
        28x"FEC2040", 28x"FEC1212", 28x"FEC0940", 28x"FEC3C12",
        28x"FE66040", 28x"FE65212", 28x"FE64940", 28x"FE67C12",
        28x"FE4A040", 28x"5E395A1", 28x"2422386", 28x"0CBD7FF"
        );
begin
------------------------------------------------------------------------------------------------------------------------------ 

    process(clk, rst) begin
        if rst = '1' then
            state <= S0;
        elsif rising_edge(clk) then
            state <= next_state;     
        end if; 
    end process; 
    
    
    process(clk) begin
        if rst = '1' then 
            credit <= (others => '0'); 
        elsif rising_edge(clk) then 
            credit <= next_credit; 
        end if; 
    end process; 
    
    
    process(clk) begin        
        if rst = '1' then 
            cntr <= (others => '0'); 
        elsif rising_edge(clk) then 
            if inc_cntr = '1' then 
                cntr <= cntr + 1; 
            elsif clr_cntr = '1' then 
                cntr <= (others => '0'); 
            end if; 
        end if; 
    end process; 
   
  
  ------------------------------------------------------------------------------------------------------------------------------------
    process(ALL) begin
        next_state <= state;  
        next_credit <= credit;  
        case state is 
            when S0 => 
                next_credit <= (others => '0'); 
                next_state <= S1; 
            when S1 => 
                display <= display_lut( to_integer( credit )); 
                if quarter then 
                    if credit < 20 then 
                        next_credit <= credit + 1; 
                    end if;
                elsif dollar then 
                    if credit <= 16 then 
                        next_credit <= credit + 4; 
                    end if; 
                elsif refund then
                    clr_cntr <= '1'; 
                    next_state <= S2; 
                elsif vend0 then 
                    if credit >= 2 then 
                        next_credit <= credit-2; 
                        clr_cntr <= '1'; 
                        next_state <= S4; 
                    else 
                        clr_cntr <= '1'; 
                        next_state <= S3; 
                    end if; 
                elsif vend1 then 
                    if credit >=4 then 
                        next_credit <= credit-4; 
                        clr_cntr <= '1'; 
                        next_state <= S4; 
                    else 
                        clr_cntr <= '1';
                        next_state <= S3; 
                    end if; 
                elsif vend2 then 
                    if credit = 20 then 
                        next_credit <= (others => '0'); 
                        clr_cntr <= '1';  
                        next_state <= S4; 
                    else 
                        clr_cntr <= '1'; 
                        next_state <= S3; 
                    end if; 
               elsif vend3 then 
                    if credit >= 9 then 
                        next_credit <= credit - 9; 
                        clr_cntr <= '1'; 
                        next_state <= S4; 
                    else 
                        clr_cntr <= '1'; 
                        next_state <= S3; 
                    end if; 
               elsif vend4 then 
                    if credit >= 7 then 
                        next_credit <= credit - 7; 
                        clr_cntr <= '1'; 
                        next_state <= S4; 
                    else 
                        clr_cntr <= '1'; 
                        next_state <= S3; 
                    end if; 
               elsif vend5 then 
                    if credit >= 12 then 
                        next_credit <= credit - 12; 
                        clr_cntr <= '1'; 
                        next_state <= S4; 
                    else 
                        clr_cntr <= '1'; 
                        next_state <= S3; 
                    end if; 
               elsif vend6 then 
                    if credit >= 18 then 
                        next_credit <= credit - 18; 
                        clr_cntr <= '1'; 
                        next_state <= S4; 
                    else 
                        clr_cntr <= '1'; 
                        next_state <= S3; 
                    end if; 
               elsif vend7 then 
                    if credit >= 3 then 
                        next_credit <= credit - 3; 
                        clr_cntr <= '1'; 
                        next_state <= S4; 
                    else 
                        clr_cntr <= '1'; 
                        next_state <= S3; 
                    end if; 
               end if;             
          when S2 => 
                 display <= display_lut(21); 
                 inc_cntr <= '1'; 
                 if cntr = x"3FFFFFF" then 
                      next_state <= S0; 
                 end if; 
          when S3 => 
                display <= display_lut(23); 
                if cntr = x"3FFFFFF" then 
                    next_state <= S1; 
                end if; 
         when S4 => 
                display <= display_lut(22); 
                if cntr = x"3FFFFFF" then 
                    next_state <= S1; 
                end if; 
        end case; 
      end process; 
end Behavioral;
