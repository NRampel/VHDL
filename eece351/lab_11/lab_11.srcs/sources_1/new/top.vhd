library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD_UNSIGNED.ALL; 

entity top is
    port(
        clk, rst, rx, tick : in std_logic; 
        data : out std_logic_vector(7 downto 0); 
        done : out std_logic 
    ); 
end top;

architecture Behavioral of top is
     signal tick_ctr : std_logic_vector(15 downto 0);
     signal clr_tick_ctr, inc_tick_ctr : std_logic;  
     signal bit_ctr : std_logic_vector(7 downto 0); 
     signal clr_bit_ctr, inc_bit_ctr : std_logic;  
     type state is (ST_IDLE, ST_START, ST_DATA, ST_STOP);  
     signal current_state, next_state : state; 
     signal shift_reg : std_logic; 
     signal data_reg  : std_logic_vector(7 downto 0);
     signal data_next : std_logic_vector(7 downto 0);
     
begin
    --State Register
    process(clk, rst) begin 
        if rising_edge(clk) then 
            if rst='1'then 
                current_state <= ST_IDLE; 
            else 
                current_state <= next_state; 
            end if; 
        end if; 
    end process; 
    
    process(clk, rst) begin
         if rst='1' then 
              tick_ctr <= (others=>'0'); 
          elsif rising_edge(clk) then 
              if inc_tick_ctr = '1' then 
                  tick_ctr <= tick_ctr + 1; 
              elsif clr_tick_ctr = '1' then 
                  tick_ctr <= (others=>'0'); 
              else 
                  tick_ctr <= tick_ctr; 
              end if; 
          end if; 
    end process; 
    
    process(clk, rst) begin
        if rst='1' then 
            bit_ctr <= (others=>'0'); 
        elsif rising_edge(clk) then 
            if inc_bit_ctr = '1' then 
                bit_ctr <= bit_ctr + 1; 
            elsif clr_bit_ctr = '1' then 
                bit_ctr <= (others=>'0'); 
            else 
                bit_ctr <= bit_ctr; 
            end if; 
        end if; 
    end process; 
    
    process(clk, rst) begin
        if rising_edge(clk) then
            data_reg <= data_next; 
        end if; 
    end process;
    
    data <= data_reg;
  
    process(ALL) begin 
        next_state <= current_state; 
        done <= '0'; 
        clr_tick_ctr <= '0'; 
        inc_tick_ctr <= '0'; 
        inc_bit_ctr <= '0'; 
        clr_bit_ctr <= '0'; 
        data_next <= data_reg; 
        case current_state is 
            when ST_IDLE => 
                done <= '1'; 
                if rx = '1' then 
                    next_state <= ST_IDLE; 
                else 
                    done <= '0'; 
                    next_state <= ST_START; 
                    clr_tick_ctr <= '1'; 
                end if; 
            when ST_START => 
                done <= '0'; 
                if tick = '0' then 
                    next_state <= ST_START; 
                else  
                    if tick_ctr /= x"000F" then 
                        inc_tick_ctr <= '1'; 
                        next_state <= ST_START; 
                    else
                        next_state <= ST_DATA; 
                        clr_tick_ctr <= '1'; 
                    end if; 
                end if; 
            when ST_DATA => 
                    if tick = '1' then 
                        if tick_ctr = x"0007" then 
                            data_next <= (rx, data_reg(7 downto 1));  
                        end if; 
                            
                        if tick_ctr = x"000F" then 
                             clr_tick_ctr <= '1'; 
                             inc_bit_ctr <= '1'; 
                             if bit_ctr = x"07" then 
                                  next_state <= ST_STOP; 
                             else 
                                  next_state <= ST_DATA; 
                            end if; 
                        else 
                            inc_tick_ctr <= '1'; 
                            next_state <= ST_DATA; 
                        end if; 
                    else 
                        next_state <= ST_DATA; 
                    end if; 
            when ST_STOP => 
                if tick = '1' then 
                    if tick_ctr = x"000F" then 
                        done <= '1'; 
                        next_state <= ST_IDLE;
                    else
                        inc_tick_ctr <= '1'; 
                        next_state <= ST_STOP; 
                    end if; 
                else 
                    next_state <= ST_STOP; 
                end if; 
        end case; 
    end process; 
end Behavioral;
