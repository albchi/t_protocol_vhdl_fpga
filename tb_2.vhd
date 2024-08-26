library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity tb_2 is
--  Port ( );
end tb_2;

architecture Behavioral_2 of tb_2 is

signal irst : std_logic;
signal iclk : std_logic := '0';
signal iinc_g : std_logic;
signal iu  : std_logic;
signal id : std_logic;


component score_keeper_top is port (
-- component sm is port ( 
        clk : in std_logic;
        rst : in std_logic;   
        btnU : in std_logic;  
        btnD : in std_logic;    
        inc_g : inout std_logic 
    );
end component;

begin

score_keeper_top_0 : score_keeper_top port map (
    clk => iclk, 
    rst => irst, 
    btnU => iu, 
    btnD => id, 
    inc_g => iinc_g
);

iclk <= not iclk after 50 ns;
irst <= '1', '0' after 200 ns;

process_stim : process begin

    iu <= '0';
    id <= '0';

    
    wait until (falling_edge(irst));


    -- ME 0->40
    for point_game in 1 to 3 loop
        --  start : wiggle btnU --- 
        for i in 0 to 4 loop
            wait until rising_edge(iclk);
        end loop;
        iu <= '1';
        wait until rising_edge(iclk);
        iu <= '0';    
        wait until rising_edge(iclk);
        
        --  end : wiggle btnU ---
    end loop; -- point_game     

    -- OPP 0->40
    for point_game in 1 to 3 loop

        --  start : wiggle btnD --- 
        for i in 1 to 3 loop
            wait until rising_edge(iclk);
        end loop;
        id <= '1';
        wait until rising_edge(iclk);
        id <= '0';    
        wait until rising_edge(iclk);
        --  end ---
     --  end : wiggle btnD --- 

    end loop; -- point_game     

    -- check for 40-40, which is deuce 
    assert iinc_g = '1' report ("INC_G should be 1") severity ERROR;
    
    -- ME 40->AI->Game = 1
    for point_game in 1 to 2 loop
        --  start : wiggle btnU --- 
        for i in 0 to 4 loop
            wait until rising_edge(iclk);
        end loop;
        iu <= '1';
        wait until rising_edge(iclk);
        iu <= '0';    
        wait until rising_edge(iclk);
        
        --  end : wiggle btnU ---
    end loop; -- point_game         


    -- check I won game
    assert iinc_g = '1' report ("INC_G should be 1") severity ERROR;



    -- OPP 0->40
    for point_game in 1 to 3 loop
        --  start : wiggle btnU --- 
        for i in 0 to 4 loop
            wait until rising_edge(iclk);
        end loop;
        id <= '1';
        wait until rising_edge(iclk);
        id <= '0';    
        wait until rising_edge(iclk);
        
        --  end : wiggle btnU ---
    end loop; -- point_game     

    -- OPP 0->40
    for point_game in 1 to 3 loop

        --  start : wiggle btnD --- 
        for i in 1 to 3 loop
            wait until rising_edge(iclk);
        end loop;
        iu <= '1';
        wait until rising_edge(iclk);
        iu <= '0';    
        wait until rising_edge(iclk);
        --  end ---
     --  end : wiggle btnD --- 

    end loop; -- point_game     

    -- check for 40-40, which is deuce 
    assert iinc_g = '1' report ("INC_G should be 1") severity ERROR;
    
    -- OPP 40->AI->Game = 1
    for point_game in 1 to 2 loop
        --  start : wiggle btnU --- 
        for i in 0 to 4 loop
            wait until rising_edge(iclk);
        end loop;
        id <= '1';
        wait until rising_edge(iclk);
        id <= '0';    
        wait until rising_edge(iclk);
        
        --  end : wiggle btnU ---
    end loop; -- point_game         


    -- check OPP won game
    assert iinc_g = '1' report ("INC_G should be 1") severity ERROR;
    

end process process_stim;

end Behavioral_2;
