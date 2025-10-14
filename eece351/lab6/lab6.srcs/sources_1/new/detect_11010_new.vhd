library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity detect_11010_new is
    port(
        clk : in std_logic; 
        rst : in std_logic; 
        en : in std_logic; 
        a : in std_logic; 
        f : out std_logic 
    );
end detect_11010_new; 

architecture mealy_fsm of detect_11010_new is
    type state_type is (S0, S1, S2, S3, S4); 
    signal current_state, next_state : state_type;
begin
    process(clk) begin
        if rising_edge(clk) then 
            if rst then
                current_state <=S0; 
            elsif en then 
                current_state <= next_state; 
            end if;
        end if; 
    end process; 
    
    process(current_state, a) begin 
        f <= '0'; 
        next_state <= current_state; 
        case current_state is
        when S0 => 
            if a = '1' then 
                next_state <= S1; 
            else
                next_state <= S0; 
            end if; 
        
        when S1 =>
            if a = '1' then
                next_state <= S2; 
            else 
                next_state <= S0; 
            end if; 
       
        when S2 => 
            if a = '0' then 
                next_state <= S3; 
            end if; 
      
        when S3 => 
            if a = '0' then 
                next_state <= S0; 
            else 
                next_state <= S4; 
            end if; 
     
        when S4 => 
            if a = '1' then 
                next_state <= S2; 
            else 
                f <= '1'; 
                next_state <= S0; 
            end if; 
        end case; 
     end process;          
end mealy_fsm;

architecture mealy_shift_register of detect_11010_new is
    signal shift_reg: std_logic_vector(3 downto 0);
    constant pattern: std_logic_vector(4 downto 0):= "11010";
begin
    process(clk) begin
        if rising_edge(clk) then
            if rst = '1' then
                shift_reg <= (others=> NOT pattern(4));
            elsif en then
                shift_reg <= shift_reg(2 downto 0) & a;
            end if;
        end if;
    end process;

    f <= '1' when (shift_reg,a) = pattern else '0';

end architecture mealy_shift_register;

architecture moore_fsm of detect_11010_new is 
     type state_type is (S00, S01, S1, S2, S3, S4); 
     signal current_state, next_state : state_type;
begin 
process(clk) begin
        if rising_edge(clk) then 
            if rst then
                current_state <=S00; 
            elsif en then 
                current_state <= next_state; 
            end if;
        end if; 
    end process; 
    
    process(current_state, a) begin 
        f <= '0'; 
        next_state <= current_state; 
        case current_state is
        when S00 => 
            if a = '1' then 
                next_state <= S1; 
            else
                next_state <= S00; 
            end if; 
        
        when S1 =>
            if a = '1' then
                next_state <= S2; 
            else 
                next_state <= S00; 
            end if; 
       
        when S2 => 
            if a = '0' then 
                next_state <= S3; 
            end if; 
      
        when S3 => 
            if a = '0' then 
                next_state <= S00; 
            else 
                next_state <= S4; 
            end if; 
     
        when S4 => 
            if a = '1' then 
                next_state <= S2; 
            else 
                f <= '1'; 
                next_state <= S01; 
            end if; 
            
       when S01 =>
            if a = '1' then 
                next_state <= S1; 
            else 
               f <= '0'; 
               next_state <= S00; 
            end if; 
                
        end case; 
     end process;
end architecture moore_fsm;

architecture moore_shift_register of detect_11010_new is
    signal shift_reg: std_logic_vector(4 downto 0);
    constant pattern: std_logic_vector(4 downto 0):= "11010";
begin
    process(clk) begin
        if rising_edge(clk) then
            if rst = '1' then
                shift_reg <= (others=> NOT pattern(5));
            elsif en then
                shift_reg <= shift_reg(3 downto 0) & a;
            end if;
        end if;
    end process;

    f <= '1' when (shift_reg,a) = pattern else '0';

end architecture moore_shift_register;           
