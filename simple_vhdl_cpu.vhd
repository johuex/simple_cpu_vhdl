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
	t: time := 2ns
);
port (
	reset: in std_logic;
	
	-- Входы инструкций на конвейеры
	in_command_1: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
	in_command_2: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
	in_command_3: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
	in_command_4: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
	in_command_5: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
	in_command_6: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0)
);
end entity simple_vhdl_cpu;

architecture cup_rtl of simple_vhdl_cpu is
signal clk: std_logic := '0';
--signal reset: std_logic := '0';
	-- Входы инструкций на конвейеры
--signal in_command_1: std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
--signal in_command_2: std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
--signal in_command_3: std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
--signal in_command_4: std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
--signal in_command_5: std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
--signal in_command_6: std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0);
-- Для каждого конвейера начало
signal value1: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные первого операнда
signal value2: std_ulogic_vector( (reg_size-1) downto 0); 				-- данные второго операнда
signal out_operand1: std_ulogic_vector((operand_length-1) downto 0); -- первый операнд, выход
signal out_operand2: std_ulogic_vector((operand_length-1) downto 0); 	-- второй операнд, выход
signal out_val: std_ulogic_vector( (reg_size-1) downto 0); 				-- выходное значение
-- Для каждого конвейера конец
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
		clk => clk,					--тактирование
		we => we, 					-- разрешение записи
		reset => reset,			-- ресет
		addr => ram_addr,			--адрес ячейки памяти
		datai => ram_val_in, 	--данные для записи в память
		datao => ram_val_out 	--данные, читаемые из памяти
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
		in_val1 => value1, 					-- данные первого операнда
		in_val2 => value2, 					-- данные второго операнда
		out_operand_1 => out_operand1, 	-- первый операнд, выход
		out_operand_2 => out_operand2, 	-- второй операнд, выход
		out_val => out_val, 					-- выходное значение
		ram_addr => ram_addr, 				-- адрес внешней памяти
		ram_val_in => ram_val_in,			-- данные во внешнюю память
		ram_val_out => ram_val_out,		-- данные с внешней памяти
		we => we,  								-- разрешение на запись в память
		we_flag_reg => we_flag_reg 		-- разрешение на запись в регистр
		-- TODO Сделать чтение регистра
		-- TODO Сделать увеличение счетчика программного PC
		-- TODO чтение\запись в RAM
	);
	
	-- Работа с регистрами
	process (clk)
	begin
		if we_flag_reg = '1' then
			
		end if;
	end process;
	
	-- Генератор тактовой частоты
	process (clk)
	begin
		if clk = '0' then
			clk <= '1' after t, '0' after 2*t;
		end if;
	end process;
	
	-- Ресет
	process (reset)
	begin
		if reset = '1' then
			REGS(0) <= x"0000";
			REGS(1) <= x"0001";
			REGS(2) <= x"0002";
			REGS(3) <= x"0003";
			REGS(4) <= x"0004";
			REGS(5) <= x"0005";
			REGS(6) <= x"0006";
			REGS(7) <= x"0007";
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
