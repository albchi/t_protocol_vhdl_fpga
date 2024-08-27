library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library global_signals;
use global_signals.all;


entity score_keeper_top is
   port ( 
        clk : in std_logic;
        rst : in std_logic;   
        btnU : in std_logic;   
        btnD : in std_logic;
        points_me : out work.global_signals.STATE; -- 
        points_opp : out work.global_signals.STATE; --         
        game_me : out  std_logic_vector(2 downto 0);--integer; -- integerout std_logic_vector(3 downto 0);
        game_opp : out std_logic_vector(2 downto 0); -- integer; -- std_logic_vector(3 downto 0);
        set_me : out integer; -- std_logic_vector(1 downto 0);
        set_opp : out integer; -- std_logic_vector(1 downto 0);
        inc_g : inout std_logic 
              
   );
end score_keeper_top;

architecture Behavioral of score_keeper_top is

-- signal irst : std_logic;
-- signal iclk : std_logic;
-- signal iu : std_logic;
-- signal id : std_logic;

-- signal points_me, points_op : work.global_signals.STATE;                 


signal inc_g_me, inc_g_opp : std_logic;
signal inc_s_me, inc_s_opp : std_logic;

signal me_40, op_40 : std_logic;
signal op_won, me_won : std_logic;

-- signal point_score_me : integer; -- unsigned(7 downto 0);
-- signal point_score_op : integer; -- unsigned(7 downto 0);

signal point_set_me : integer; -- unsigned(7 downto 0);
signal point_set_op : integer; -- unsigned(7 downto 0);
signal a,b : work.global_signals.STATE;

use work.global_signals.all; -- Declare the package

component sm is port ( 
        clk : in std_logic;
        rst : in std_logic;   
        u : in std_logic;  
        d : in std_logic; 
        op_40 : in std_logic;  
        op_won : in std_logic;     
        i_40 : out std_logic;
        i_won : out std_logic;           
        me_point_state : out work.global_signals.STATE;
        op_point_state : in  work.global_signals.STATE;           
        gscore : inout integer; 
        inc_s : out std_logic;   
        game_score : out std_logic_vector(2 downto 0);                                            
        inc_g : inout std_logic 
        
          
    );
end component;

component hex2seven is port (
    clk     : in std_logic;
    rst     : in std_logic;
    display_digit : in  std_logic_vector(3 downto 0);
    seg7    : out STD_LOGIC_VECTOR (6 downto 0);
    an      : out STD_LOGIC_VECTOR (3 downto 0)
); -- port
end component;

begin

set_me <= point_set_me;
set_opp <= point_set_op;

sm_me : sm port map (
    clk => clk,
    rst => rst,
    u => btnU, -- iu,
    d => btnD, -- id,
    op_40 => op_40,  
    op_won => op_won,     
    i_won => me_won,
    i_40 => me_40,
    me_point_state => a, -- points_me,
    op_point_state => b, -- points_opp,    
    gscore => gscore_me,
    inc_s => inc_s_me,
    game_score => game_me,
    inc_g => inc_g_me -- *** TO DO *** inc_g_me

);

sm_op : sm port map (
    clk => clk,
    rst => rst,
    u => btnD, -- id,
    d => btnU, --iu,
    op_40 => me_40,
    op_won => me_won,     
    i_won => op_won,
    i_40 => op_40,    
    me_point_state => b, -- points_op,
    op_point_state => a, -- points_me,    
    gscore => gscore_op,  
    inc_s => inc_s_opp,
    game_score => game_opp,
    inc_g => inc_g_opp
    
);

process_set_score_op : process (clk, rst, inc_g_opp) begin
    if (rising_edge (clk)) then
        if (rst = '1') then 
            point_set_op <= 0;
        elsif (inc_s_opp = '1') then
            point_set_op <= point_set_op + 1;
        end if;
    end if; -- clk
            
end process; -- process_set_score_op

process_set_score_me : process (clk, rst, inc_g_me) begin
    if (rising_edge (clk)) then
        if (rst = '1') then 
            point_set_me <= 0; -- point_set_me <= 0;
        elsif (inc_s_me = '1') then
            point_set_me <= point_set_me + 1;
        end if;
    end if; -- clk
            
end process; -- process_set_score_me
-- point_score_me <= 0 when (points_me = work.global_signals.STATE.S00);
--point_me <= 0 when (points_me = S00) else
--                    15 when (points_me = S15) else
--                    30 when (points_me = S30) else
--                    40 when (points_me = S40) else
--                    99; -- 99 is bad

-- point_score_op <= 0 when (points_op = S00) else
--point_opp <= 0 when (points_op = S00) else
--                    15 when (points_op = S15) else
--                    30 when (points_op = S30) else
--                    40 when (points_op = S40) else
--                    99; -- 99 is bad

points_me <= a;
points_opp <= b;

end Behavioral;

