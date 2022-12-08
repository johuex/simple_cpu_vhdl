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
	reg_size: integer := 16;
	mem_size: integer := 1024;
	reg_count: integer := 8;
	t: time := 2ns
);
--port (
--	reset: in std_logic;
--	
--	-- Входы инструкций на конвейеры
--	in_command_1: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
--	in_command_2: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
--	in_command_3: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
--	in_command_4: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
--	in_command_5: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
--	in_command_6: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0)
--);
end entity simple_vhdl_cpu;

architecture cup_rtl of simple_vhdl_cpu is

signal reset: std_logic := '0';
-- Входы инструкций на конвейеры
signal in_command_1: std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
signal in_command_2: std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
signal in_command_3: std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
signal in_command_4: std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
signal in_command_5: std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
signal in_command_6: std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);

signal clk: std_logic := '0';
-- Для каждого конвейера начало
signal value1_1: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные первого операнда
signal value2_1: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные второго операнда
signal out_operand1_1: std_ulogic_vector((operand_length-1) downto 0); 	-- первый операнд, выход
signal out_operand2_1: std_ulogic_vector((operand_length-1) downto 0); 	-- второй операнд, выход
signal out_val_1: std_ulogic_vector( (reg_size-1) downto 0); 				-- выходное значение
signal we_reg_1: std_logic; 															-- разрешение на запись в регистр
signal flag_idle_1: std_logic := '0';												-- сигнал блокировки конвейера
signal ram_val_in_1: std_ulogic_vector( (reg_size-1) downto 0); 			-- данные для записи в память
signal ram_val_out_1: std_ulogic_vector( (reg_size-1) downto 0); 			-- данные для чтения из памяти
signal ram_addr_1: std_ulogic_vector( (addr_length-1) downto 0); 			-- адрес внешней памяти
signal we_1: std_logic; 																-- разрешение на запись в память

signal value1_2: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные первого операнда
signal value2_2: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные второго операнда
signal out_operand1_2: std_ulogic_vector((operand_length-1) downto 0); 	-- первый операнд, выход
signal out_operand2_2: std_ulogic_vector((operand_length-1) downto 0); 	-- второй операнд, выход
signal out_val_2: std_ulogic_vector( (reg_size-1) downto 0); 				-- выходное значение
signal we_reg_2: std_logic; 															-- разрешение на запись в регистр
signal flag_idle_2: std_logic := '0';													-- сигнал блокировки конвейера
signal ram_val_in_2: std_ulogic_vector( (reg_size-1) downto 0); 			-- данные для записи в память
signal ram_val_out_2: std_ulogic_vector( (reg_size-1) downto 0); 			-- данные для чтения из памяти
signal ram_addr_2: std_ulogic_vector( (addr_length-1) downto 0); 			-- адрес внешней памяти
signal we_2: std_logic; 																-- разрешение на запись в память

signal value1_3: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные первого операнда
signal value2_3: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные второго операнда
signal out_operand1_3: std_ulogic_vector((operand_length-1) downto 0); 	-- первый операнд, выход
signal out_operand2_3: std_ulogic_vector((operand_length-1) downto 0); 	-- второй операнд, выход
signal out_val_3: std_ulogic_vector( (reg_size-1) downto 0); 				-- выходное значение
signal we_reg_3: std_logic; 															-- разрешение на запись в регистр
signal flag_idle_3: std_logic := '0';												-- сигнал блокировки конвейера
signal ram_val_in_3: std_ulogic_vector( (reg_size-1) downto 0); 			-- данные для записи в память
signal ram_val_out_3: std_ulogic_vector( (reg_size-1) downto 0); 			-- данные для чтения из памяти
signal ram_addr_3: std_ulogic_vector( (addr_length-1) downto 0); 			-- адрес внешней памяти
signal we_3: std_logic; 																-- разрешение на запись в память

signal value1_4: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные первого операнда
signal value2_4: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные второго операнда
signal out_operand1_4: std_ulogic_vector((operand_length-1) downto 0); 	-- первый операнд, выход
signal out_operand2_4: std_ulogic_vector((operand_length-1) downto 0); 	-- второй операнд, выход
signal out_val_4: std_ulogic_vector( (reg_size-1) downto 0); 				-- выходное значение
signal we_reg_4: std_logic; 															-- разрешение на запись в регистр
signal flag_idle_4: std_logic := '0';												-- сигнал блокировки конвейера
signal ram_val_in_4: std_ulogic_vector( (reg_size-1) downto 0); 			-- данные для записи в память
signal ram_val_out_4: std_ulogic_vector( (reg_size-1) downto 0); 			-- данные для чтения из памяти
signal ram_addr_4: std_ulogic_vector( (addr_length-1) downto 0); 			-- адрес внешней памяти
signal we_4: std_logic; 																-- разрешение на запись в память

signal value1_5: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные первого операнда
signal value2_5: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные второго операнда
signal out_operand1_5: std_ulogic_vector((operand_length-1) downto 0); 	-- первый операнд, выход
signal out_operand2_5: std_ulogic_vector((operand_length-1) downto 0); 	-- второй операнд, выход
signal out_val_5: std_ulogic_vector( (reg_size-1) downto 0); 				-- выходное значение
signal we_reg_5: std_logic; 															-- разрешение на запись в регистр
signal flag_idle_5: std_logic := '0';												-- сигнал блокировки конвейера
signal ram_val_in_5: std_ulogic_vector( (reg_size-1) downto 0); 			-- данные для записи в память
signal ram_val_out_5: std_ulogic_vector( (reg_size-1) downto 0); 			-- данные для чтения из памяти
signal ram_addr_5: std_ulogic_vector( (addr_length-1) downto 0); 			-- адрес внешней памяти
signal we_5: std_logic; 																-- разрешение на запись в память

signal value1_6: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные первого операнда
signal value2_6: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные второго операнда
signal out_operand1_6: std_ulogic_vector((operand_length-1) downto 0); 	-- первый операнд, выход
signal out_operand2_6: std_ulogic_vector((operand_length-1) downto 0); 	-- второй операнд, выход
signal out_val_6: std_ulogic_vector( (reg_size-1) downto 0); 				-- выходное значение
signal we_reg_6: std_logic; 															-- разрешение на запись в регистр
signal flag_idle_6: std_logic := '0';												-- сигнал блокировки конвейера
signal ram_val_in_6: std_ulogic_vector( (reg_size-1) downto 0); 			-- данные для записи в память
signal ram_val_out_6: std_ulogic_vector( (reg_size-1) downto 0); 			-- данные для чтения из памяти
signal ram_addr_6: std_ulogic_vector( (addr_length-1) downto 0); 			-- адрес внешней памяти
signal we_6: std_logic; 																-- разрешение на запись в память

-- Для каждого конвейера конец


begin
	-- Оперативная память
	RAM : entity work.memory
	generic map(
		addr_length => addr_length,
		reg_size => reg_size,
		mem_size => mem_size
	)
	port map(
		clk => clk,							-- тактирование
		reset => reset,					-- ресет
		
		we_1 => we_1, 						-- разрешение записи
		addr_1 => ram_addr_1,			-- адрес ячейки памяти
		datai_1 => ram_val_in_1, 		-- данные для записи в память
		datao_1 => ram_val_out_1, 		-- данные, читаемые из памяти
		
		we_2 => we_2, 						-- разрешение записи
		addr_2 => ram_addr_2,			-- адрес ячейки памяти
		datai_2 => ram_val_in_2, 		-- данные для записи в память
		datao_2 => ram_val_out_2, 		-- данные, читаемые из памяти
		
		we_3 => we_3, 						-- разрешение записи
		addr_3 => ram_addr_3,			-- адрес ячейки памяти
		datai_3 => ram_val_in_3, 		-- данные для записи в память
		datao_3 => ram_val_out_3, 		-- данные, читаемые из памяти
		
		we_4 => we_4, 						-- разрешение записи
		addr_4 => ram_addr_4,			-- адрес ячейки памяти
		datai_4 => ram_val_in_4, 		-- данные для записи в память
		datao_4 => ram_val_out_4, 		-- данные, читаемые из памяти
		
		we_5 => we_5, 						-- разрешение записи
		addr_5 => ram_addr_5,			-- адрес ячейки памяти
		datai_5 => ram_val_in_5, 		-- данные для записи в память
		datao_5 => ram_val_out_5, 		-- данные, читаемые из памяти
		
		we_6 => we_6, 						-- разрешение записи
		addr_6 => ram_addr_6,			-- адрес ячейки памяти
		datai_6 => ram_val_in_6, 		-- данные для записи в память
		datao_6 => ram_val_out_6 		-- данные, читаемые из памяти
	);
	
	-- Решала конфликтов
	conflict_resolver : entity work.conflict_resolver
	generic map(
		command_length => command_length,
		operand_length => operand_length,
		addr_length => addr_length,
		reg_size => reg_size
	)
	port map(
		clk => clk,							-- тактирование
		reset => reset,					-- ресет
		flag_idle_1 => flag_idle_1,
		in_data_1 => in_command_1,
		flag_idle_2 => flag_idle_2,
		in_data_2 => in_command_2,
		flag_idle_3 => flag_idle_3,
		in_data_3 => in_command_3,
		flag_idle_4 => flag_idle_4,
		in_data_4 => in_command_4,
		flag_idle_5 => flag_idle_5,
		in_data_5 => in_command_5,
		flag_idle_6 => flag_idle_6,
		in_data_6 => in_command_6
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
		reset => reset,   						-- ресет
		clk => clk, 								-- тактирование
		in_data => in_command_1, 				-- входные данные
		in_val1 => value1_1, 					-- данные первого операнда
		in_val2 => value2_1, 					-- данные второго операнда
		out_operand_1 => out_operand1_1, 	-- первый операнд, выход
		out_operand_2 => out_operand2_1, 	-- второй операнд, выход
		out_val => out_val_1, 					-- выходное значение
		ram_addr => ram_addr_1, 					-- адрес внешней памяти
		ram_val_in => ram_val_in_1,				-- данные во внешнюю память
		ram_val_out => ram_val_out_1,			-- данные с внешней памяти
		we => we_1,  									-- разрешение на запись в память
		we_flag_reg => we_reg_1, 				-- разрешение на запись в регистр
		flag_idle => flag_idle_1           	-- сигнал блокировки
	);
	
	conveyor_2 : entity work.conveyor
	generic map(
		command_length => command_length,
		operand_length => operand_length,
		addr_length => addr_length,
		reg_size => reg_size
	)
	port map(
		reset => reset,   						-- ресет
		clk => clk, 								-- тактирование
		in_data => in_command_2, 				-- входные данные
		in_val1 => value1_2, 					-- данные первого операнда
		in_val2 => value2_2, 					-- данные второго операнда
		out_operand_1 => out_operand1_2, 	-- первый операнд, выход
		out_operand_2 => out_operand2_2, 	-- второй операнд, выход
		out_val => out_val_2, 					-- выходное значение
		ram_addr => ram_addr_2, 					-- адрес внешней памяти
		ram_val_in => ram_val_in_2,				-- данные во внешнюю память
		ram_val_out => ram_val_out_2,			-- данные с внешней памяти
		we => we_2,  									-- разрешение на запись в память
		we_flag_reg => we_reg_2, 				-- разрешение на запись в регистр
		flag_idle => flag_idle_2           	-- сигнал блокировки
	);
	
	conveyor_3 : entity work.conveyor
	generic map(
		command_length => command_length,
		operand_length => operand_length,
		addr_length => addr_length,
		reg_size => reg_size
	)
	port map(
		reset => reset,   						-- ресет
		clk => clk, 								-- тактирование
		in_data => in_command_3, 				-- входные данные
		in_val1 => value1_3, 					-- данные первого операнда
		in_val2 => value2_3, 					-- данные второго операнда
		out_operand_1 => out_operand1_3, 	-- первый операнд, выход
		out_operand_2 => out_operand2_3, 	-- второй операнд, выход
		out_val => out_val_3, 					-- выходное значение
		ram_addr => ram_addr_3, 					-- адрес внешней памяти
		ram_val_in => ram_val_in_3,				-- данные во внешнюю память
		ram_val_out => ram_val_out_3,			-- данные с внешней памяти
		we => we_3,  									-- разрешение на запись в память
		we_flag_reg => we_reg_3, 				-- разрешение на запись в регистр
		flag_idle => flag_idle_3           	-- сигнал блокировки
	);
	
	conveyor_4 : entity work.conveyor
	generic map(
		command_length => command_length,
		operand_length => operand_length,
		addr_length => addr_length,
		reg_size => reg_size
	)
	port map(
		reset => reset,   						-- ресет
		clk => clk, 								-- тактирование
		in_data => in_command_4, 				-- входные данные
		in_val1 => value1_4, 					-- данные первого операнда
		in_val2 => value2_4, 					-- данные второго операнда
		out_operand_1 => out_operand1_4, 	-- первый операнд, выход
		out_operand_2 => out_operand2_4, 	-- второй операнд, выход
		out_val => out_val_4, 					-- выходное значение
		ram_addr => ram_addr_4, 					-- адрес внешней памяти
		ram_val_in => ram_val_in_4,				-- данные во внешнюю память
		ram_val_out => ram_val_out_4,			-- данные с внешней памяти
		we => we_4,  									-- разрешение на запись в память
		we_flag_reg => we_reg_4, 			-- разрешение на запись в регистр
		flag_idle => flag_idle_4           	-- сигнал блокировки
	);
	
	conveyor_5 : entity work.conveyor
	generic map(
		command_length => command_length,
		operand_length => operand_length,
		addr_length => addr_length,
		reg_size => reg_size
	)
	port map(
		reset => reset,   						-- ресет
		clk => clk, 								-- тактирование
		in_data => in_command_5, 				-- входные данные
		in_val1 => value1_5, 					-- данные первого операнда
		in_val2 => value2_5, 					-- данные второго операнда
		out_operand_1 => out_operand1_5, 	-- первый операнд, выход
		out_operand_2 => out_operand2_5, 	-- второй операнд, выход
		out_val => out_val_5, 					-- выходное значение
		ram_addr => ram_addr_5, 					-- адрес внешней памяти
		ram_val_in => ram_val_in_5,				-- данные во внешнюю память
		ram_val_out => ram_val_out_5,			-- данные с внешней памяти
		we => we_5,  									-- разрешение на запись в память
		we_flag_reg => we_reg_5, 			-- разрешение на запись в регистр
		flag_idle => flag_idle_5           	-- сигнал блокировки
	);
	
	conveyor_6 : entity work.conveyor
	generic map(
		command_length => command_length,
		operand_length => operand_length,
		addr_length => addr_length,
		reg_size => reg_size
	)
	port map(
		reset => reset,   						-- ресет
		clk => clk, 								-- тактирование
		in_data => in_command_6, 				-- входные данные
		in_val1 => value1_6, 					-- данные первого операнда
		in_val2 => value2_6, 					-- данные второго операнда
		out_operand_1 => out_operand1_6, 	-- первый операнд, выход
		out_operand_2 => out_operand2_6, 	-- второй операнд, выход
		out_val => out_val_6, 					-- выходное значение
		ram_addr => ram_addr_6, 					-- адрес внешней памяти
		ram_val_in => ram_val_in_6,				-- данные во внешнюю память
		ram_val_out => ram_val_out_6,			-- данные с внешней памяти
		we => we_6,  									-- разрешение на запись в память
		we_flag_reg => we_reg_6, 			-- разрешение на запись в регистр
		flag_idle => flag_idle_6           	-- сигнал блокировки
	);
	-- Регистры
	REGS : entity work.registers
	generic map(
		addr_length => operand_length,
		reg_size => reg_size,
		reg_count => reg_count
	)
	port map(
		clk => clk,
		reset => reset,
		
		we_1 => we_reg_1,
		addr1_1 => out_operand1_1,
		addr2_1 => out_operand2_1,
		datai_1 => out_val_1,
		datao1_1 => value1_1,
		datao2_1 => value2_1,
		
		we_2 => we_reg_2,
		addr1_2 => out_operand1_2,
		addr2_2 => out_operand2_2,
		datai_2 => out_val_2,
		datao1_2 => value1_2,
		datao2_2 => value2_2,
		
		we_3 => we_reg_3,
		addr1_3 => out_operand1_3,
		addr2_3 => out_operand2_3,
		datai_3 => out_val_3,
		datao1_3 => value1_3,
		datao2_3 => value2_3,
		
		we_4 => we_reg_4,
		addr1_4 => out_operand1_4,
		addr2_4 => out_operand2_4,
		datai_4 => out_val_4,
		datao1_4 => value1_4,
		datao2_4 => value2_4,
		
		we_5 => we_reg_5,
		addr1_5 => out_operand1_5,
		addr2_5 => out_operand2_5,
		datai_5 => out_val_5,
		datao1_5 => value1_5,
		datao2_5 => value2_5,
		
		we_6 => we_reg_6,
		addr1_6 => out_operand1_6,
		addr2_6 => out_operand2_6,
		datai_6 => out_val_6,
		datao1_6 => value1_6,
		datao2_6 => value2_6
	);
	
	-- Генератор тактовой частоты
	process (clk)
	begin
		if clk = '0' then
			clk <= '1' after t, '0' after 2*t;
		end if;
	end process;
	
	-- Testbench
    testbench: process is
    begin
		in_command_1 <= "1100000000000000"; -- STORE r0 00000000
		in_command_2 <= "1000010000000000"; -- LOAD r1 00000000
		in_command_3 <= "0000100000000011"; -- ADD r2, r3
		in_command_4 <= "0101110000000110"; -- SUB r7, r6
		in_command_5 <= "0001000000000101"; -- ADD r4, r5
		in_command_6 <= "1101100000000001"; -- STORE r6, 00000001
		reset <= '1';
		wait for 4 ns;
		reset <= '0';
		wait for 8 ns;
		in_command_1 <= "0000010000000011"; -- ADD r1, r3
		in_command_3 <= "0001000000000011"; -- ADD r4, r3
		in_command_4 <= "0001010000000011"; -- ADD r5, r3
		in_command_5 <= "0001100000000011"; -- ADD r6, r3
		in_command_6 <= "0001110000000011"; -- ADD r7, r3
		wait for 18 ns;
		in_command_2 <= "0000100000000011"; -- ADD r2, r3
		wait;
	end process testbench;
end architecture;
