library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_counter is
    generic (
        counter_bits : integer := 8
    );
    port (
        clk       : in std_logic;
        rstn      : in std_logic;
        en        : in std_logic;
        up        : in std_logic;
        down      : in std_logic;
        rst_value : in unsigned (counter_bits - 1 downto 0);
        cnt       : out unsigned (counter_bits - 1 downto 0)
    );
end entity;

architecture beh of generic_counter is
    signal i_counter_val      : unsigned (counter_bits - 1 downto 0);
    signal i_counter_val_next : unsigned (counter_bits - 1 downto 0);
begin
    -- Output
    cnt <= i_counter_val;

    -- Next counter value
    i_counter_val_next <= rst_value when rstn = '0'
        else i_counter_val when en = '0'
        else i_counter_val + 1 when up = '1' and down = '0'
        else i_counter_val - 1 when down = '1' and up = '0'
        else i_counter_val;

    -- Positive edge detector
    process (clk) is
    begin
        if rising_edge(clk) then
            i_counter_val <= i_counter_val_next;
        end if;
    end process;

end architecture;
