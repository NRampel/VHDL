library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 

entity sqrt8i is 
    port(
        a : in std_logic_vector(7 downto 0); 
        clk, rst, start : in std_logic; 
        done : out std_logic; 
        sqrt : out unsigned(3 downto 0)
    ); 
end entity sqrt8i; 

architecture Behavioral of sqrt8i is 
    type state is (STEP_1, STEP_2, STEP_3); 
    signal current_state, next_state : state; 
    
    signal rega : unsigned(7 downto 0); 
    signal acc : unsigned(8 downto 0); 
    signal odd : unsigned(8 downto 0); 
    signal sqrt_reg : unsigned(3 downto 0); 
    signal sqrt_add, sqrt_dec : std_logic; 
    signal rega_load, acc_load, odd_load, sqrt_load, init : std_logic; 
    
begin 

    --State Regisrer
    process(clk) begin
        if rising_edge(clk) then
            if rst = '1' then
                current_state <= STEP_1; 
            else
                current_state <= next_state; 
            end if; 
        end if; 
    end process; 
    
    --Acc register
    process(clk) begin
        if rising_edge(clk) then 
            if acc_load = '1' then
                if init = '1' then
                    acc <= (others => '0'); 
                else 
                    acc <= acc + odd; 
                end if; 
            end if; 
        end if; 
    end process; 
   
   --Loading Register A process;  
    process(clk) begin 
        if rising_edge(clk) then 
            if rega_load = '1' then 
                rega <= unsigned(a);  
            end if; 
        end if; 
    end process; 
    
    --Loading Odd Register Process
    process(clk) begin
        if rising_edge(clk) then 
            if odd_load = '1' then
                if init = '1' then
                    odd <= to_unsigned(1, odd'length); 
                else
                    odd <= odd + 2;  
                end if; 
            end if; 
        end if; 
   end process; 
  
   --Loading Square Root Process: 
   process(clk) begin
       if rising_edge(clk) then 
            if sqrt_load = '1' then
                if init = '1' then 
                    sqrt_reg <= (others => '0'); 
                elsif sqrt_add = '1' then 
                    sqrt_reg <= sqrt_reg + 1; 
                elsif sqrt_dec = '1' then 
                    sqrt_reg <= sqrt_reg - 1; 
                end if; 
            end if; 
       end if; 
   end process; 
                
   sqrt <= sqrt_reg; 

--main process
    process(ALL) begin 
        next_state <= current_state; 
        rega_load <= '0'; 
        acc_load <= '0'; 
        odd_load <= '0'; 
        sqrt_load <= '0'; 
        init <= '0'; 
        done <= '0';
        sqrt_add <= '0'; 
        sqrt_dec <= '0';  
        case current_state is 
            when STEP_1 => 
                if start = '1' then
                    init <= '1'; 
                    rega_load <= '1'; 
                    acc_load <= '1'; 
                    sqrt_load <= '1'; 
                    odd_load <= '1'; 
                    next_state <= STEP_2; 
                end if; 
            when STEP_2 => 
                if acc >= ('0' & rega) then 
                    if acc > ('0' & rega) then
                        sqrt_dec <= '1'; 
                        sqrt_load <= '1'; 
                    end if; 
                    next_state <= STEP_3; 
                else 
                    acc_load <= '1'; 
                    odd_load <= '1'; 
                    sqrt_add <= '1'; 
                    sqrt_load <= '1'; 
                    next_state <= STEP_2; 
                end if; 
                
           when STEP_3 => 
                done <= '1'; 
                if start = '0' then
                    next_state <= STEP_1; 
                end if; 
         end case; 
       end process; 
                    
end Behavioral; 
        
        
 