--top level vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity simple_vhdl_cpu is
generic (
	command_length: integer := 2; 
	operand_length: integer := 4;
	addr_length: integer := 4;
	cell_size: integer := 16; -- размер ячейки
	reg_size: integer := 10; -- кол-во регистров
	ram_size: integer := 10;  -- кол-во ячеек в ram
	t: time := 2ns;
	reg_count: integer := 10
);
--port (
---- Входы инструкций на конвейеры
--	in_command_1: in std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
--	in_command_2: in std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
--	in_command_3: in std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
--	in_command_4: in std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
--	in_command_5: in std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
--	in_command_6: in std_logic_vector((command_length + operand_length + addr_length - 1) downto 0)
--);
end entity simple_vhdl_cpu;

architecture cpu_rtl of simple_vhdl_cpu is
constant time_var : time := t;
signal clk: std_logic := '0';
signal reset: std_logic := '0';

signal in_command_1: std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
signal in_command_2: std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
signal in_command_3: std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
signal in_command_4: std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
signal in_command_5: std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);

-- Для каждого конвейера входы и выходы
-- TODO мб убрать обнуление сигнала
signal reg_value1_1: std_logic_vector( (cell_size-1) downto 0); 				-- данные первого операнда
signal reg_value2_1: std_logic_vector( (cell_size-1) downto 0); 				-- данные второго операнда
signal out_operand1_1: std_logic_vector((operand_length-1) downto 0); -- первый операнд, выход
signal out_operand2_1: std_logic_vector((operand_length-1) downto 0); 	-- второй операнд, выход
signal reg_out_val_1: std_logic_vector( (cell_size-1) downto 0); 				-- выходное значение
signal we_flag_reg_1: std_logic := '0';
signal we_ram_flag_1: std_logic := '0';
signal ram_addr_1: std_logic_vector( (addr_length-1) downto 0);
signal ram_val_in_1: std_logic_vector( (cell_size-1) downto 0);
signal ram_val_out_1: std_logic_vector( (cell_size-1) downto 0);
signal idle_flag_1: std_logic := '0';

signal reg_value1_2: std_logic_vector( (cell_size-1) downto 0);
signal reg_value2_2: std_logic_vector( (cell_size-1) downto 0);
signal out_operand1_2: std_logic_vector((operand_length-1) downto 0);
signal out_operand2_2: std_logic_vector((operand_length-1) downto 0);
signal reg_out_val_2: std_logic_vector( (cell_size-1) downto 0);
signal we_flag_reg_2: std_logic := '0';
signal we_ram_flag_2: std_logic := '0';
signal ram_addr_2: std_logic_vector( (addr_length-1) downto 0);
signal ram_val_in_2: std_logic_vector( (cell_size-1) downto 0);
signal ram_val_out_2: std_logic_vector( (cell_size-1) downto 0);
signal idle_flag_2: std_logic := '0';

signal reg_value1_3: std_logic_vector( (cell_size-1) downto 0);
signal reg_value2_3: std_logic_vector( (cell_size-1) downto 0);
signal out_operand1_3: std_logic_vector((operand_length-1) downto 0);
signal out_operand2_3: std_logic_vector((operand_length-1) downto 0); 
signal reg_out_val_3: std_logic_vector( (cell_size-1) downto 0);
signal we_flag_reg_3: std_logic := '0';
signal we_ram_flag_3: std_logic := '0';
signal ram_addr_3: std_logic_vector( (addr_length-1) downto 0);
signal ram_val_in_3: std_logic_vector( (cell_size-1) downto 0);
signal ram_val_out_3: std_logic_vector( (cell_size-1) downto 0);
signal idle_flag_3: std_logic := '0';

signal reg_value1_4: std_logic_vector( (cell_size-1) downto 0);
signal reg_value2_4: std_logic_vector( (cell_size-1) downto 0);
signal out_operand1_4: std_logic_vector((operand_length-1) downto 0);
signal out_operand2_4: std_logic_vector((operand_length-1) downto 0);
signal reg_out_val_4: std_logic_vector( (cell_size-1) downto 0);
signal we_flag_reg_4: std_logic := '0';
signal we_ram_flag_4: std_logic := '0';
signal ram_addr_4: std_logic_vector( (addr_length-1) downto 0);
signal ram_val_in_4: std_logic_vector( (cell_size-1) downto 0);
signal ram_val_out_4: std_logic_vector( (cell_size-1) downto 0);
signal idle_flag_4: std_logic := '0';

signal reg_value1_5: std_logic_vector( (cell_size-1) downto 0);
signal reg_value2_5: std_logic_vector( (cell_size-1) downto 0);
signal out_operand1_5: std_logic_vector((operand_length-1) downto 0);
signal out_operand2_5: std_logic_vector((operand_length-1) downto 0); 
signal reg_out_val_5: std_logic_vector( (cell_size-1) downto 0);
signal we_flag_reg_5: std_logic := '0';
signal we_ram_flag_5: std_logic := '0';
signal ram_addr_5: std_logic_vector( (addr_length-1) downto 0);
signal ram_val_in_5: std_logic_vector( (cell_size-1) downto 0);
signal ram_val_out_5: std_logic_vector( (cell_size-1) downto 0);
signal idle_flag_5: std_logic := '0';
 
begin
	
	-- компонент, на который подаем команды и с помощью которого решаем конфликты обращения к внешней памяти
	conflict_resolver : entity work.conflict_resolver
	generic map(
		command_length => command_length,
		operand_length => operand_length,
		addr_length => addr_length,
		reg_size => reg_size
	)
	port map(
		clk => clk,
		reset => reset,
		flag_idle_1 => idle_flag_1, -- флаг простоя на конвеер
		in_data_1 => in_command_1, -- команда, которую подаем на конвеер
		flag_idle_2 => idle_flag_2,
		in_data_2 => in_command_2,
		flag_idle_3 => idle_flag_3,
		in_data_3 => in_command_3,
		flag_idle_4 => idle_flag_4,
		in_data_4 => in_command_4,
		flag_idle_5 => idle_flag_5,
		in_data_5 => in_command_5
	);
	
	-- Оперативная память
	RAM : entity work.memory
	generic map(
		addr_length => addr_length,
		reg_size => cell_size,
		mem_size => ram_size
	)
	port map(
		clk => clk,
		reset => reset,
		we_1 => we_ram_flag_1,				
		addr_1 => ram_addr_1,	
		wr_data_1 => ram_val_in_1,
		out_data_1 => ram_val_out_1,

		we_2 => we_ram_flag_2,				
		addr_2 => ram_addr_2,	
		wr_data_2 => ram_val_in_2,
		out_data_2 => ram_val_out_2,
		
		we_3 => we_ram_flag_3,				
		addr_3 => ram_addr_3,	
		wr_data_3 => ram_val_in_3,
		out_data_3 => ram_val_out_3,

		we_4 => we_ram_flag_4,				
		addr_4 => ram_addr_4,	
		wr_data_4 => ram_val_in_4,
		out_data_4 => ram_val_out_4,

		we_5 => we_ram_flag_5,				
		addr_5 => ram_addr_5,	
		wr_data_5 => ram_val_in_5,
		out_data_5 => ram_val_out_5
	);
	
	-- регистры
	registries: entity work.registers
	generic map(
		addr_length => addr_length,
		reg_size => cell_size,
		mem_size => reg_size
	)
	port map(
		clk => clk,
		reset => reset,
		we_1 => we_flag_reg_1,
		rd1_addr_1 => out_operand1_1,
		rd2_addr_1 => out_operand2_1,
		wr_data_1 => reg_out_val_1,
		rd1_data_1 => reg_value1_1,
		rd2_data_1 => reg_value2_1,
		
		we_2 => we_flag_reg_2,
		rd1_addr_2 => out_operand1_2,
		rd2_addr_2 => out_operand2_2,
		wr_data_2 => reg_out_val_2,
		rd1_data_2 => reg_value1_2,
		rd2_data_2 => reg_value2_2,
		
		we_3 => we_flag_reg_3,
		rd1_addr_3 => out_operand1_3,
		rd2_addr_3 => out_operand2_3,
		wr_data_3 => reg_out_val_3,
		rd1_data_3 => reg_value1_3,
		rd2_data_3 => reg_value2_3,

		we_4 => we_flag_reg_4,
		rd1_addr_4 => out_operand1_4,
		rd2_addr_4 => out_operand2_4,
		wr_data_4 => reg_out_val_4,
		rd1_data_4 => reg_value1_4,
		rd2_data_4 => reg_value2_4,

		we_5 => we_flag_reg_5,
		rd1_addr_5 => out_operand1_5,
		rd2_addr_5 => out_operand2_5,
		wr_data_5 => reg_out_val_5,
		rd1_data_5 => reg_value1_5,
		rd2_data_5 => reg_value2_5
	);

	-- Конвейеры
	conveyor_1 : entity work.conveyor
	generic map(
		command_length => command_length,
		operand_length => operand_length,
		addr_length => addr_length,
		reg_size => cell_size
	)
	port map(
		reset => reset, 
		clk => clk, 
		in_data => in_command_1, 
		reg_in_val1 => reg_value1_1, 
		reg_in_val2 => reg_value2_1, 
		out_operand_1 => out_operand1_1,
		out_operand_2 => out_operand2_1,
		reg_out_val => reg_out_val_1,
		ram_addr => ram_addr_1,
		ram_val_in => ram_val_in_1,
		ram_val_out => ram_val_out_1,
		we_ram_flag => we_ram_flag_1,
		we_flag_reg => we_flag_reg_1,
		idle_flag => idle_flag_1
	);
	
	conveyor_2 : entity work.conveyor
	generic map(
		command_length => command_length,
		operand_length => operand_length,
		addr_length => addr_length,
		reg_size => cell_size
	)
	port map(
		reset => reset, 
		clk => clk, 
		in_data => in_command_2, 
		reg_in_val1 => reg_value1_2, 
		reg_in_val2 => reg_value2_2, 
		out_operand_1 => out_operand1_2,
		out_operand_2 => out_operand2_2,
		reg_out_val => reg_out_val_2,
		ram_addr => ram_addr_2,
		ram_val_in => ram_val_in_2,
		ram_val_out => ram_val_out_2,
		we_ram_flag => we_ram_flag_2,
		we_flag_reg => we_flag_reg_2,
		idle_flag => idle_flag_2
	);

	conveyor_3 : entity work.conveyor
	generic map(
		command_length => command_length,
		operand_length => operand_length,
		addr_length => addr_length,
		reg_size => cell_size
	)
	port map(
		reset => reset, 
		clk => clk, 
		in_data => in_command_3, 
		reg_in_val1 => reg_value1_3, 
		reg_in_val2 => reg_value2_3, 
		out_operand_1 => out_operand1_3,
		out_operand_2 => out_operand2_3,
		reg_out_val => reg_out_val_3,
		ram_addr => ram_addr_3,
		ram_val_in => ram_val_in_3,
		ram_val_out => ram_val_out_3,
		we_ram_flag => we_ram_flag_3,
		we_flag_reg => we_flag_reg_3,
		idle_flag => idle_flag_3
	);

	conveyor_4 : entity work.conveyor
	generic map(
		command_length => command_length,
		operand_length => operand_length,
		addr_length => addr_length,
		reg_size => cell_size
	)
	port map(
		reset => reset, 
		clk => clk, 
		in_data => in_command_4, 
		reg_in_val1 => reg_value1_4, 
		reg_in_val2 => reg_value2_4, 
		out_operand_1 => out_operand1_4,
		out_operand_2 => out_operand2_4,
		reg_out_val => reg_out_val_4,
		ram_addr => ram_addr_4,
		ram_val_in => ram_val_in_4,
		ram_val_out => ram_val_out_4,
		we_ram_flag => we_ram_flag_4,
		we_flag_reg => we_flag_reg_4,
		idle_flag => idle_flag_4
	);

	conveyor_5 : entity work.conveyor
	generic map(
		command_length => command_length,
		operand_length => operand_length,
		addr_length => addr_length,
		reg_size => cell_size
	)
	port map(
		reset => reset, 
		clk => clk, 
		in_data => in_command_5, 
		reg_in_val1 => reg_value1_5, 
		reg_in_val2 => reg_value2_5, 
		out_operand_1 => out_operand1_5,
		out_operand_2 => out_operand2_5,
		reg_out_val => reg_out_val_5,
		ram_addr => ram_addr_5,
		ram_val_in => ram_val_in_5,
		ram_val_out => ram_val_out_5,
		we_ram_flag => we_ram_flag_5,
		we_flag_reg => we_flag_reg_5,
		idle_flag => idle_flag_5
	);
	
	--Генератор тактовой частоты
	process (clk)
	begin
		if clk = '0' then
			clk <= '1' after t, '0' after 2*t;
		end if;
	end process;
	
-- Testbench
	testbench: process is
	begin
		reset <= '1';
		wait for 4 ns;
		reset <= '0';
		wait for 4 ns;
		-- TODO переделать бенч ???
		in_command_1 <= "1000000001"; -- SUM r0, r1
		in_command_2 <= "1000100011"; -- SUM r2, r3
		in_command_3 <= "1101000101"; -- MUL r4, r5
		in_command_4 <= "0001100010"; -- LOAD r8, m2
		in_command_5 <= "1001100110"; -- SUM r6, r7
	
		wait for 50 ns;
		-- тут конфликт
		in_command_1 <= "0000010010"; -- LOAD r1, m2
		in_command_2 <= "0100000010"; -- STORE r0, m2
		wait;
	end process testbench;
end architecture;
