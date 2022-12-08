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
	t: time := 2ns
);
end testbench;

architecture testbench_rtl of testbench is
	signal command_1 : std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
	signal command_2 : std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
	signal command_3 : std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
	signal command_4 : std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
	signal command_5 : std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
	signal reset : std_logic := '0';
	signal clk: std_logic := '0';
	constant time_var : time := t;
begin
	top_level: entity work.simple_vhdl_cpu
	port map (
		in_command_1 => command_1,
		in_command_2 => command_2,
		in_command_3 => command_3,
		in_command_4 => command_4,
		in_command_5 => command_5,
		clk => clk,
		reset => reset
	);
	
	process is
	begin
		reset <= '1';
		wait for time_var;
		reset <= '0';
		wait for time_var;
		-- TODO correct byre view
		command_1 <= "1000000001"; -- SUM r0, r1
		command_2 <= "1000100011"; -- SUM r2, r3
		command_3 <= "1101000101"; -- MUL r4, r5
		command_4 <= "0001100010"; -- LOAD r8, m2
		command_5 <= "1001100110"; -- SUM r6, r7
	
		wait for 2*time_var;
		-- тут конфликт
		-- TODO correct byre view
		command_1 <= "0001100010"; -- LOAD r7, m2
		command_2 <= "0100000010"; -- STORE r0, m2
		wait for 2*time_var;
  
		wait for 2*time_var;
  
		wait for 2*time_var;
  
		wait;
	end process;
	
	-- подаем clk на top-level
	process (clk)
	begin
		if clk = '0' then
			clk <= '1' after time_var, '0' after 2*time_var;
		end if;
	end process;
end architecture;