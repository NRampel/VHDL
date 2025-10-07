library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           a : in STD_LOGIC;
           f : out STD_LOGIC);
end fsm;

architecture Behavioral of fsm is

type state_t is (S0, S1, S2, S3);
signal state, next_state: state_t;
begin

    process(clk) begin
        if rising_edge(clk) then
            if reset then
                state <= S0;
            else
                state <= next_state;
            end if;
        end if;
    end process;
    
    process(ALL) begin
       --defaults
       next_state <= state;
       f <= '0';
       case state is 
            when S0=>
                next_state <= S1 when a;
            when S1=>
                next_state <= S2 when a='0' else S3;
                f <= '1';
            when S2=>
                next_state <= S0 when a='1' else S2;
                f <= '1' when a='0';
            when S3=>
                next_state <= S2;
            when others=>
       end case;
    end process;

end Behavioral;
