-- conveyor
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conveyor is 
generic (
	command_length: integer := 2; -- разрядность команды
	operand_length: integer := 4; -- разрядность операнда (регистр или память)
	addr_length: integer := 4; -- разрядность второго операнда или памяти
	reg_size: integer := 16 -- размер регистра (должен быть равен размеру ячейки памяти)
);
port ( --входы и выходы
		reset: in std_logic; --ресет
		clk: in std_logic; --тактирование
		in_data: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0); -- входные данные (команда + операнды и тд)
		reg_in_val1: in std_ulogic_vector( (reg_size-1) downto 0); -- значение первого операнда, получаем из регистра
		reg_in_val2: in std_ulogic_vector( (reg_size-1) downto 0); -- значение второго операнда, получаем из регистра
		out_operand_1: out std_ulogic_vector((operand_length-1) downto 0); -- получить значение первого операнда, регистр
		out_operand_2: out std_ulogic_vector((operand_length-1) downto 0); -- получить значение второго операнда, регистр
		reg_out_val: out std_ulogic_vector( (reg_size-1) downto 0); -- выходное значение операции, для записи в регистр
		ram_addr: out std_ulogic_vector( (addr_length-1) downto 0); -- обращаемся к RAM по адресу
		ram_val_in: out std_ulogic_vector( (reg_size-1) downto 0); -- данные в RAM
		ram_val_out: in std_ulogic_vector( (reg_size-1) downto 0); -- данные из RAM
		we_ram_flag: out std_logic; -- разрешение на запись в RAM
		we_flag_reg: out std_logic; -- разрешение на запись в регистр
		idle_flag: in std_logic -- флаг простоя конвеера
);
end entity conveyor;

architecture conveyor_rtl of conveyor is
signal counter: integer := 0; -- внутренний "счетчик" тактов на конвеере
signal mul_counter : integer := 0; --для задержки в 4 такта на умножении
signal now_command : std_ulogic_vector( (command_length - 1) downto 0); -- Код команды
signal now_operand_1 : std_ulogic_vector( (operand_length - 1) downto 0); -- Операнд 1
signal now_operand_2 : std_ulogic_vector( (addr_length - 1) downto 0); -- Операнд 2
signal value_operand_1 : std_ulogic_vector( (reg_size - 1) downto 0); -- Данные операнда 1
signal value_operand_2 : std_ulogic_vector( (reg_size - 1) downto 0); -- Данные операнда 2
begin
	process (clk)
	begin
		if (clk'event and clk = '1') then 		
			if (idle_flag = '0') then -- проверка команды остановки процессора
				case counter is
					when 0 => -- выборка команды
					-- TODO тут не работает парсер
						now_command <= in_data((command_length + operand_length + addr_length - 1) downto (operand_length + addr_length));
						now_operand_1 <= in_data((operand_length + addr_length - 1) downto addr_length);
						now_operand_2 <= in_data((addr_length - 1) downto 0);
						counter <= 1;
					when 1 => -- выборка операндов
						case to_integer(unsigned(now_command)) is
							when 0 => -- load
								-- отправляем запрос на чтение значения из внешней памяти, второй операнд
								we_ram_flag <= '0';
								ram_addr <= now_operand_2;
							when 1 | 2 | 3 => --  store, add or sub
								-- отправляем запрос на чтение значений из регистров
								out_operand_1 <= now_operand_1;
								out_operand_2 <= now_operand_2;
							when others => 
						end case;
						counter <= 2;
					when 2 => -- вычисление результата
						case to_integer(unsigned(now_command)) is
							when 0 => -- load
								-- получаем значение из памяти
								value_operand_1 <= ram_val_out;
								counter <= 3;
							when 1 => -- store
								-- получаем значение из регистра первого операнда
								-- получаем адрес для записи в память
								value_operand_1 <= reg_in_val1;
								value_operand_2 <= reg_in_val2;
								-- TODO проверить тестбенч и в регистр записать адрес
								--value_operand_2 <= now_operand_2;  --  было "000000" & now_operand_2; -- добавляем до 10 бит
								counter <= 3;
							when 2 => -- add
								value_operand_1 <= std_ulogic_vector( unsigned(reg_in_val1) + unsigned(reg_in_val2) );
								counter <= 3;
							when 3 => -- mul
								value_operand_1 <= std_ulogic_vector( unsigned(reg_in_val1(reg_size/2-1 downto 0)) * unsigned(reg_in_val2(reg_size/2-1 downto 0)) ); --expression has 32 elements, but must have 16 elements
								-- wait 4 такта
								if mul_counter < 4 then
									mul_counter <= mul_counter + 1;
								else
									counter <= 3;
								end if;
							when others =>
						end case;
					when 3 => -- запись результата				
						if (to_integer(unsigned(now_command)) = 0) then --load
								-- пишем значение в регистр первого операнда
								we_flag_reg <= '1';
								reg_out_val <= value_operand_1;
						end if;
						if (to_integer(unsigned(now_command)) = 1) then --store
								-- пишем значение из регистра в память
								we_ram_flag <='1';
								ram_addr <= value_operand_2((addr_length - 1) downto 0);
								ram_val_in <= value_operand_1;
						end if;
						if (to_integer(unsigned(now_command)) = 2) then  -- add
								we_flag_reg <= '1';
								reg_out_val <= value_operand_1;
						end if;
						if (to_integer(unsigned(now_command)) = 3) then  -- sub
								we_flag_reg <= '1';
								reg_out_val <= value_operand_1;
						end if;
						-- обнуляем переменные
						we_flag_reg <= '0';
						we_ram_flag <= '0';
						counter <= 0;
						mul_counter <= 0;
					when others =>
				end case;
			end if;
		end if;
	end process;
end architecture;

