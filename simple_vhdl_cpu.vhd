--top level vhdl

-- global TODO: connect registers and ram with conveyors + describe flags and connect them

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity simple_vhdl_cpu is
generic (
	command_length: integer := 2; 
	operand_length: integer := 4;
	addr_length: integer := 10;
	reg_size: integer := 16;
	mem_size: integer := 1024;
	t: time := 2ns
	reg_count: integer := 10;
);
port (
	reset: in std_logic;
	-- подача команд на конвейеры
	in_command_1: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
	in_command_2: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
	in_command_3: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
	in_command_4: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
	in_command_5: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0)
);
end entity simple_vhdl_cpu;

architecture cpu_rtl of simple_vhdl_cpu is
-- Для каждого конвейера начало
signal value1_1: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные первого операнда
signal value2_1: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные второго операнда
signal out_operand1_1: std_ulogic_vector((operand_length-1) downto 0); -- первый операнд, выход
signal out_operand2_1: std_ulogic_vector((operand_length-1) downto 0); 	-- второй операнд, выход
signal out_val_1: std_ulogic_vector( (reg_size-1) downto 0); 				-- выходное значение
signal we_reg_1: std_logic; 

signal value1_2: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные первого операнда
signal value2_2: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные второго операнда
signal out_operand1_2: std_ulogic_vector((operand_length-1) downto 0); -- первый операнд, выход
signal out_operand2_2: std_ulogic_vector((operand_length-1) downto 0); 	-- второй операнд, выход
signal out_val_2: std_ulogic_vector( (reg_size-1) downto 0); 				-- выходное значение
signal we_reg_2: std_logic; 

signal value1_3: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные первого операнда
signal value2_3: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные второго операнда
signal out_operand1_3: std_ulogic_vector((operand_length-1) downto 0); -- первый операнд, выход
signal out_operand2_3: std_ulogic_vector((operand_length-1) downto 0); 	-- второй операнд, выход
signal out_val_3: std_ulogic_vector( (reg_size-1) downto 0); 				-- выходное значение
signal we_reg_3: std_logic; 

signal value1_4: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные первого операнда
signal value2_4: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные второго операнда
signal out_operand1_4: std_ulogic_vector((operand_length-1) downto 0); -- первый операнд, выход
signal out_operand2_4: std_ulogic_vector((operand_length-1) downto 0); 	-- второй операнд, выход
signal out_val_4: std_ulogic_vector( (reg_size-1) downto 0); 				-- выходное значение
signal we_reg_4: std_logic; 

signal value1_5: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные первого операнда
signal value2_5: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные второго операнда
signal out_operand1_5: std_ulogic_vector((operand_length-1) downto 0); -- первый операнд, выход
signal out_operand2_5: std_ulogic_vector((operand_length-1) downto 0); 	-- второй операнд, выход
signal out_val_5: std_ulogic_vector( (reg_size-1) downto 0); 				-- выходное значение
signal we_reg_5: std_logic; 

--Для каждого конвейера конец ???
signal ram_val_in: std_ulogic_vector( (reg_size-1) downto 0); 			-- данные для записи в память
signal ram_val_out: std_ulogic_vector( (reg_size-1) downto 0); 			-- данные для чтения из памяти
signal ram_addr: std_ulogic_vector( (addr_length-1) downto 0); 		-- адрес внешней памяти
signal we: std_logic; 																-- разрешение на запись в память
signal we_flag_reg: std_logic; 													-- разрешение на запись в регистр

-- Регистры общего назначения
type reg_array is array(0 to 7) of std_logic_vector((reg_size-1) downto 0);
signal REGS: reg_array;
-- Программный счетчик
signal PC: std_logic_vector(7 downto 0) := (others => '0');
begin
	-- Оперативная память
	RAM : entity work.memory
	generic map(
		addr_length => addr_length,
		reg_size => reg_size,
		mem_size => mem_size
	)
	port map(
		clk => clk,
		reset => reset,
		we_1 => ,				
		rd1_addr_1 => ,			
		rd2_addr_1 => , 	
		wr_addr_1 => ,
		wr_data_1 => ,
		rd1_data_1 => ,
		rd2_data_1 => ,
		conveyor_idle_1 => ,
		-- todo соединить со всеми конвеерами
	);
	
	-- Конвейеры
	conveyor_1 : entity work.conveyor
	generic map(
		command_length => command_length,
		operand_length => operand_length,
		addr_length => addr_length,
		reg_size => reg_size
	)
	port map(
		reset => reset,   					-- ресет
		clk => clk, 							-- тактирование
		in_data => in_command_1, 			-- входные данные
		in_val1 => value1_1, 					-- данные первого операнда
		in_val2 => value2_1, 					-- данные второго операнда
		out_operand_1 => , 	-- первый операнд, выход
		out_operand_2 => , 	-- второй операнд, выход
		out_val => , 					-- выходное значение
		ram_addr => ram_addr, 				-- адрес внешней памяти
		ram_val_in => ram_val_in,			-- данные во внешнюю память
		ram_val_out => ram_val_out,		-- данные с внешней памяти
		we => we,  								-- разрешение на запись в память
		we_flag_reg => we_flag_reg, 		-- разрешение на запись в регистр
		idle_flag => 
	);
	-- TODO добавить контейнеры
	
	-- Генератор тактовой частоты
	process (clk)
	begin
		if clk = '0' then
			clk <= '1' after t, '0' after 2*t;
		end if;
	end process;
	
--	-- Testbench
--    testbench: process is
--    begin
--		reset <= '1';
--		wait for 2 ns;
--		reset <= '0';
--		wait for 2 ns;
--		in_command_1 <= "1000000000000000"; -- LOAD r0 00000000
--		--in_command_2 <= "1000100000000010"; -- LOAD r1 00000010
--		--in_command_3 <= "0000110000000100"; -- ADD r3, r4
--		--in_command_4 <= "1000110000000000"; -- LOAD r3 00000000
--		--in_command_5 <= "0101010000000100"; -- SUB r5, r4
--		--in_command_6 <= "0001100000000100"; -- ADD r6, r4
--		wait for 4 ns;
--		in_command_1 <= "1101110000000001"; -- STORE r7 00000001
--		--in_command_2 <= "11000000000000"; -- STORE r0 00000000
--		wait for 4 ns;
--	  
--		wait for 4 ns;
--	  
--		wait for 4 ns;
--	  
--		wait;
--	end process testbench;
end architecture;
