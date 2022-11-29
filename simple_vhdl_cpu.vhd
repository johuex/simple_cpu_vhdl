--top level vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity simple_vhdl_cpu is
generic (
	command_length: integer := 2; 
	operand_length: integer := 4;
	addr_length: integer := 10;
	t: time := 2ns
);
port (
	reset: in std_logic;
	clk: out std_logic
);
end entity simple_vhdl_cpu;

architecture cup_rtl of simple_vhdl_cpu is
begin
	clock_gen : entity work.clk_generator
	generic map(t => t)
	port map(
		clk_out => clk
	);
end architecture;
