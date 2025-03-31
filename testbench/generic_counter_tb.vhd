library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_counter_tb is
end entity;

architecture beh of generic_counter_tb is
	component generic_counter is
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
	end component;

	constant freq        : integer := 50; -- MHz
	constant period      : time    := 1000 / freq * 1 ns;
	constant half_period : time    := period / 2;

	signal num_rising_edges : integer := 0;

	signal clock  : std_logic := '0';
	signal enable : std_logic;
	signal resetn : std_logic;

	signal cnt_value : unsigned (8 downto 0);

	signal running : boolean := true;
begin
	running <= true, false after 530 * period;

	resetn <= '1', '0' after 2 * period, '1' after 3 * period;

	enable <= '0', '1' after 5 * period;

	DUT : generic_counter
	generic map(
		counter_bits => 9
	)
	port map(
		clk  => clock,
		rstn => resetn,
		en   => enable,
		up   => '1',
		down => '0',
		rst_value => (others => '0'),
		cnt  => cnt_value
	);

	DUT2 : generic_counter
	generic map(
		counter_bits => 9
	)
	port map(
		clk       => clock,
		rstn      => resetn,
		en        => enable,
		up        => '0',
		down      => '1',
		rst_value => to_unsigned(16#005#, 9),
		cnt       => open
	);

	DUT3 : generic_counter
	generic map(
		counter_bits => 9
	)
	port map(
		clk       => clock,
		rstn      => resetn,
		en        => enable,
		up        => '1',
		down      => '1',
		rst_value => to_unsigned(16#100#, 9),
		cnt       => open
	);

	-- clock process
	process is
	begin
		if running then
			wait for half_period;
			clock <= not clock;
		else report "End of simulation!";
			wait;
		end if;
	end process;
	process (clock) is
	begin
		if rising_edge(clock) then
			if resetn = '0' then
				num_rising_edges <= 0;
			elsif enable = '1' then
				num_rising_edges <= num_rising_edges + 1;
			else -- Explicit no change
				num_rising_edges <= num_rising_edges;
			end if;
		end if;
	end process;

	-- Automated checks
	process (clock) is
	begin
		if rising_edge(clock) then
			--and num_rising_edges > 1 then
			--assert (divided_en and divided_en_last) = 0 report "Enable signal longer than one clock signal detected!" severity error;
		end if;
	end process;
end architecture;
