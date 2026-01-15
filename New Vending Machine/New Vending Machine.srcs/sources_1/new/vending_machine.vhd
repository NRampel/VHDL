library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD_UNSIGNED.ALL; 

entity vending_machine is
    port ( 
        vend : in std_logic_vector(7 downto 0); 
        clk, rst, refund, quarter, dollar : in std_logic; 
        display : out std_logic_vector(27 downto 0); 
        vend_out : out std_logic 
    );    
end vending_machine;

architecture Behavioral of vending_machine is
    type state_t is (S0, S1, S2, S3, S4); 
    signal current_state, next_state : state_t; 
    signal credit, next_credit : std_logic_vector(4 downto 0); 
    signal ctr : std_logic_vector(27 downto 0); 
    signal inc_ctr, clr_ctr : std_logic; 
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
    process(clk, rst) begin 
        if rst='1' then 
            current_state <= S0; 
        elsif rising_edge(clk) then 
            current_state <= next_state; 
        end if; 
    end process; 
    
     process(clk, rst) begin 
        if rst='1' then 
            credit <= (others=>'0'); 
        elsif rising_edge(clk) then 
            credit <= next_credit; 
        end if; 
    end process; 
    
   process(clk, rst) begin 
        if rst = '1' then 
            ctr <= (others=>'0'); 
        elsif rising_edge(clk) then 
            if inc_ctr = '1' then 
                ctr <= ctr + 1; 
            elsif clr_ctr = '1' then 
                ctr <= (others=>'0'); 
            end if; 
        end if; 
    end process; 
    
    STATE_MACHINE : process(ALL) begin 
        next_state <= current_state; 
        next_credit <= credit; 
        display <= display_lut(to_integer(credit)); 
        inc_ctr <= '0'; 
        clr_ctr <= '0';
        vend_out <= '0';
        case current_state is 
            when S0 => 
                next_credit <= (others=>'0'); 
                next_state <= S1; 
            when S1 => 
                display <= display_lut(to_integer(credit)); 
                if refund then
                    clr_ctr <= '1'; 
                    next_state <= S2;
                elsif quarter then 
                    if credit < 20 then 
                        next_credit <= credit + 1; 
                    end if; 
                elsif dollar then 
                    if credit <= 16 then 
                        next_credit <= credit + 4; 
                    end if; 
                elsif vend(0) then 
                  vend_out <= '1'; 
                  if credit >= 2 then 
                        next_credit <= credit-2; 
                        clr_ctr <= '1'; 
                        next_state <= S4; 
                    else 
                        clr_ctr <= '1'; 
                        next_state <= S3; 
                    end if; 
                elsif vend(1) then 
                    vend_out <= '1'; 
                    if credit >=4 then 
                        next_credit <= credit-4; 
                        clr_ctr <= '1'; 
                        next_state <= S4; 
                    else 
                        clr_ctr <= '1';
                        next_state <= S3; 
                    end if; 
                elsif vend(2) then 
                    vend_out <= '1'; 
                    if credit = 20 then 
                        next_credit <= (others => '0'); 
                        clr_ctr <= '1';  
                        next_state <= S4; 
                    else 
                        clr_ctr <= '1'; 
                        next_state <= S3; 
                    end if; 
               elsif vend(3) then
                    vend_out <= '1'; 
                    if credit >= 9 then 
                        next_credit <= credit - 9; 
                        clr_ctr <= '1'; 
                        next_state <= S4; 
                    else 
                        clr_ctr <= '1'; 
                        next_state <= S3; 
                    end if; 
               elsif vend(4) then
                    vend_out <= '1';
                    if credit >= 7 then 
                        next_credit <= credit - 7; 
                        clr_ctr <= '1'; 
                        next_state <= S4; 
                    else 
                        clr_ctr <= '1'; 
                        next_state <= S3; 
                    end if; 
               elsif vend(5) then
                    vend_out <= '1'; 
                    if credit >= 12 then 
                        next_credit <= credit - 12; 
                        clr_ctr <= '1'; 
                        next_state <= S4; 
                    else 
                        clr_ctr <= '1'; 
                        next_state <= S3; 
                    end if; 
               elsif vend(6) then
                    vend_out <= '1';
                    if credit >= 18 then 
                        next_credit <= credit - 18; 
                        clr_ctr <= '1'; 
                        next_state <= S4; 
                    else 
                        clr_ctr <= '1'; 
                        next_state <= S3; 
                    end if; 
               elsif vend(7) then
                    vend_out <= '1'; 
                    if credit >= 3 then 
                        next_credit <= credit - 3; 
                        clr_ctr <= '1'; 
                        next_state <= S4; 
                    else 
                        clr_ctr <= '1'; 
                        next_state <= S3; 
                    end if; 
               end if;             
          when S2 => 
                 display <= display_lut(21); 
                 inc_ctr <= '1'; 
                 if ctr = x"3FFFFFF" then 
                      next_state <= S0; 
                 end if; 
          when S3 => 
                display <= display_lut(23); 
                inc_ctr <= '1';
                if ctr = x"3FFFFFF" then  
                    next_state <= S1; 
                end if; 
         when S4 => 
                display <= display_lut(22); 
                inc_ctr <= '1';
                if ctr = x"3FFFFFF" then 
                    next_state <= S1; 
                end if;
         end case; 
     end process; 

end Behavioral;
