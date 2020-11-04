
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_tb is
end entity;

architecture arch of counter_tb is

    constant CLK_MHZ : real := 1000.0; -- MHz
    signal clk, reset_n : std_logic := '0';
    
    signal DONE : std_logic_vector(0 downto 0) := (others => '0');
    
    constant W : positive := 32;
    signal cnt : std_logic_vector(W-1 downto 0);
    
begin

    clk <= not clk after (0.5 us / CLK_MHZ);
    reset_n <= '0', '1' after (1.0 us / CLK_MHZ);
    
    e_counter : entity work.counter
    generic map (
        W => W--,
    )
    port map (
        o_cnt       => cnt,
        i_ena       => '1',

        i_reset_n   => reset_n,
        i_clk       => clk--,
    );
    
    process
    begin
        wait until rising_edge(reset_n);

        loop
            wait until rising_edge(clk);
            report "o_cnt = " & work.util.to_hstring(cnt);
            exit when ( cnt = x"000000FF" );
        end loop;

        DONE(0) <= '1';
        wait;
    end process;
    
    process
    begin
        wait for 4000 ns;
        assert ( DONE = (DONE'range => '1') ) severity failure;
        wait;
    end process;

end architecture;
