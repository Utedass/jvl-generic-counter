# jvl-generic-counter

Jegatron VHDL Library - Generic Counter

Entity: generic_counter

Counts up or down at each positive clock flank when en = '1' and either up or down = '1'. Otherwise keeps it value.

When rstn = '0' the counter will be loaded with rst_value.

Declaring component

```vhdl
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
```

Instantiating

```vhdl
	my_9bit_counter : generic_counter
	generic map(
		counter_bits => 9
	)
	port map(
		clk  => my_clock_signal,
		rstn => my_resetn_signal,
		en   => my_enable_signal,
		up   => '1', -- Always counting up
		down => '0',
		rst_value => (others => '0'), -- Starts from zero
		cnt  => my_cnt_signal
	);
```
