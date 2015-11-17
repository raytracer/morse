library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity osc4 is
    port (F8M, F500K, F16K, F490, F15 : out std_ulogic);
end osc4;
architecture osc4_F15 of osc4 is
    constant CLOCK_PERIOD: time := 66666 us;
begin
    CLOCK_GENERATION: process
    begin F15 <= '0';
        wait for CLOCK_PERIOD/2;
        F15 <= '1';
        wait for CLOCK_PERIOD/2;
    end process;
end osc4_F15;
