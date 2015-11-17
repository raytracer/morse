library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity press_duration is
    port ( clock, resetpin, sparepin: in std_logic;
    short_press, long_press, long_pause: out std_logic);
end press_duration;

architecture functional_behavior of press_duration is
    signal sh: std_logic_vector (10 downto 0);
begin
    long_pause <= '1' when sh="00000000000" else '0';
    short_press <= not sh(0) and sh(1) and not sh(4);
    long_press <= '1' when sh(5 downto 0)="111110" and sh(10)='0'
                  else '0';
       -- besser: '1' when sh(5 downto 0)="111110" and
       -- not( sh(6) and sh(7) and sh(8) and sh(9) and sh(10))
       -- else '0';
        RESET_and_CLOCK_HANDLING: process (clock, resetpin)
        begin
            if resetpin='0' then sh <= (others=>'0');
            elsif clock='1' and clock'event then
                sh <= sh(9 downto 0) & not sparepin;
            end if;
        end process;
end architecture functional_behavior;
