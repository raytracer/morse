library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity morse is
    port (resetpin, sparepin: in std_logic;
          seg7: out std_logic_vector(6 downto 0);
          led3: out std_logic_vector(2 downto 0));
end morse;

architecture structure of morse is
    component osc4
        port ( F8M, F500K, F16K , F490, F15: out std_ulogic);
    end component;
    component press_duration
        port ( clock, resetpin, sparepin: in std_logic;
        short_press, long_press, long_pause: out std_logic);
    end component;
    signal clk, short, long, pause: std_logic;
    signal token: std_logic_vector(9 downto 0);
begin
    ClockGen: osc4
    port map (F8M=>open, F500K=>open, F16K=>open,
              F490=>open, F15 => clk);
    PressDur: press_duration
    port map (clock => clk, resetpin => resetpin,
              sparepin => sparepin, short_press => short,
              long_press => long, long_pause => pause);
    led3(0) <= not short; -- kurzer Impuls erkannt
    led3(1) <= not long; -- langer Impuls erkannt
    led3(2) <= not pause; -- Pause erkannt
    process (resetpin,clk)
    begin
        if resetpin='0' then
            token <= (others=>'0');
            seg7 <= (others =>'1');
        elsif clk='1' and clk'event then
            if short='1' then
                token <= token(7 downto 0) & "01"; -- kurzer Impuls
            elsif long='1' then
                token <= token(7 downto 0) & "11"; -- langer Impuls
            elsif pause='1' then -- Ende des Zeichens erreicht
                                     -- 7-Segment-Anzeige kann angesteuert werden
                case token is
                    when "0000000111" => seg7 <="0001000"; -- A
                    when "0011011101" => seg7 <="1000110"; -- C
                    when "0000000001" => seg7 <="0000110"; -- E
                    when "0001011101" => seg7 <="0001110"; -- F
                    when "0001010101" => seg7 <="0001001"; -- H
                    when "0001110101" => seg7 <="1000111"; -- L
                    when "0001111101" => seg7 <="0001100"; -- P
                    when "0000010111" => seg7 <="1000001"; -- U
                    when "1111111111" => seg7 <="1000000"; -- 0
                    when "0111111111" => seg7 <="1111001"; -- 1
                    when "0101111111" => seg7 <="0100100"; -- 2
                    when "0101011111" => seg7 <="0110000"; -- 3
                    when "0101010111" => seg7 <="0011001"; -- 4
                    when "0101010101" => seg7 <="0010010"; -- 5
                    when "1101010101" => seg7 <="0000010"; -- 6
                    when "1111010101" => seg7 <="1111000"; -- 7
                    when "1111110101" => seg7 <="0000000"; -- 8
                    when "1111111101" => seg7 <="0010000"; -- 9
                    when others => seg7 <= "0111111"; -- Fehlerausgabe "-"
                end case; -- fehlt! token <= (others => 0); 
            end if;
        end if;
    end process;
end architecture;
