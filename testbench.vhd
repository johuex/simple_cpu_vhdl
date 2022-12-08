-- Testbench
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity testbench is
generic (
	command_length: integer := 2; 
	operand_length: integer := 4;
	addr_length: integer := 4;
	t: time := 2ns;
);
end testbench;

architecture testbench_rtl of testbench is
	signal command_1, command_2, command_3, command_4, command_5: std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
begin
	top_level: work.simple_vhdl_cpu
	port map (
		in_command_1 => command_1,
		in_command_2 => command_2,
		in_command_3 => command_3,
		in_command_4 => command_4,
		in_command_5 => command_5,
		reset => reset
	);
	
	process is
	begin
		reset <= '1';
		wait for t ns;
		reset <= '0';
		wait for t ns;
		-- TODO correct byre view
		command_1 <= "1000000000000000"; -- SUM r0, r1
		command_2 <= "1000100000000010"; -- SUM r2, r3
		command_3 <= "0000110000000100"; -- MUL r4, r5
		command_4 <= "1000110000000000"; -- LOAD r8 00000010
		command_5 <= "0101010000000100"; -- SUM r6, r7
	
		wait for 2*t ns;
		-- тут конфликт
		-- TODO correct byre view
		command_1 <= "1101110000000001"; -- LOAD r7 00000010
		command_2 <= "11000000000000"; -- STORE r0 00000010
		wait for 2*t ns;
  
		wait for 2*t ns;
  
		wait for 2*t ns;
  
		wait;
	end process;
end architecture;