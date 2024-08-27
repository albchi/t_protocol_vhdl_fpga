library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library global_signals;
use global_signals.all;

entity sm is
    Port ( 
        clk : in std_logic;
        rst : in std_logic;   
        u : in std_logic;  
        d : in std_logic; 
        op_40 : in std_logic;
        op_won : in std_logic;
        i_40 : out std_logic;
        i_won : out std_logic;
        me_point_state : out work.global_signals.STATE;
        op_point_state : in work.global_signals.STATE;
        gscore : inout integer;
        inc_s : out std_logic;    
        game_score : out std_logic_vector(2 downto 0);
        inc_g : inout std_logic -- should be out
    );
end sm;

architecture Behavioral of sm is

use work.global_signals.all; -- Declare the package
-- type STATE is (S00, S15, S30, S40, SAI, SAO);
signal ps, ns : STATE;
-- signal cnt : unsigned(3 downto 0);
-- signal game_score : std_logic_vector(2 downto 0);
signal u_game_score : unsigned(2 downto 0);
signal u_game_score_f : unsigned(2 downto 0);

-- signal inc_g : std_logic;


begin

i_40 <= '1' when ps = S40 else '0';
me_point_state <= ps;
game_score <= std_logic_vector(u_game_score);
-- gscore_me  <= TO_INTEGER(u_game_score); -- multiple driver

process_ugame_score_f_me : process (clk, rst, u_game_score) begin
    if (rising_edge (clk)) then
        u_game_score_f <= u_game_score;
    end if;
end process; 

process_inc_s : process (clk, rst, u_game_score) begin
    if (rising_edge(clk)) then
        if (rst = '1') then
            inc_s <= '0';
        elsif (u_game_score = 0 and u_game_score_f = 6) then
            inc_s <= '1';
        else
            inc_s <= '0';
        end if;
     end if; 
end process; -- process_inc_s

process_state : process (clk, rst, ps) begin
   if (rising_edge(clk)) then
        if (rst = '1') then
            ps <= S00;
        else
            ps <= ns;
        end if; -- rst    
    end if; -- clk
end process process_state;

process_ns : process(ps, u, d, op_won, op_40) begin

    case(ps) is 
        when S00 =>
            inc_g <= '0';
            i_won <= '0';
            if (u = '1') then
                ns <= S15;
            end if;
        when S15 =>
            if (op_won = '1') then
                ns <= S00; 
            elsif (u = '1') then
                ns <= S30;
            end if;              
        when S30 =>
            if (op_won = '1') then
                ns <= S00;
            elsif (u = '1') then
                ns <= S40;
            end if;                
        when S40 =>
            if (u = '1' and op_40 /= '1') then
                ns <= S00;
                inc_g <= '1';
                i_won <= '1';
            -- elsif (u = '1' and op_40 = '1') then -- op_point_state
            elsif (u = '1' and op_point_state = S40) then -- op_point_state
                ns <= SAI;
            -- elsif (d = '1' and op_40 = '1') then
            elsif (d = '1' and op_point_state = S40) then
                ns <= SAO;
            elsif (d = '1' and op_won = '1') then
                ns <= S00;
            else
                ns <= S40;
            end if;                

        when SAI =>
            if (u = '1' and (op_point_state = S40 or op_point_state = SAO)) then
                ns <= S00;
                inc_g <= '1';
                i_won <= '1';
            elsif (d = '1') then
                ns <= S40;
            
           --  elsif (op_won = '1') then
            --    ns <= S00;
            else
                ns <= SAI;
            end if;  
 
 
        when SAO =>
            if (d = '1' and op_point_state = S40) then
                ns <= S00;
            -- elsif (op_won = '1') then
            --    ns <= S00;
            elsif (u = '1') then
                ns <= S40;
            elsif (op_won = '1') then
                ns <= S00;                
            else
                ns <= SAO;
            end if;  
  
        when others =>
            ns <= S00;   
    end case;
end process process_ns;

process_game_score : process (rst, clk, inc_g, u_game_score) begin
    if (rising_edge (clk)) then
        if ( (rst = '1')) then
            u_game_score <= (others => '0');
        elsif (inc_g = '1') then
            if (u_game_score = 6) then 
                u_game_score <= (others => '0');
            else
                u_game_score <= u_game_score + 1;
        end if;
    end if;
        
end process;

end Behavioral;
