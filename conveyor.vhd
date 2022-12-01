-- conveyor
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity conveyor is 
generic (
	command_length: integer := 2; -- разрядность команды
	operand_length: integer := 4; -- разрядность операнда (регистр или память)
	addr_length: integer := 10; -- разрядность второго операнда или памяти
	reg_size: integer := 16 -- размер регистра (должен быть равен размеру ячейки памяти)
);
port ( --входы и выходы
		reset: in std_logic; --ресет
		clk: in std_logic; --тактирование
		in_data: in std_ulogic_vector((command_length + operand_length + addr_length - 1) downto 0); -- входные данные
		in_val1: in std_ulogic_vector( (reg_size-1) downto 0); -- данные первого операнда
		in_val2: in std_ulogic_vector( (reg_size-1) downto 0); -- данные второго операнда
		-- out_command: out std_ulogic_vector((command_length-1) downto 0); -- команда на выход
		out_operand_1: out std_ulogic_vector((operand_length-1) downto 0); -- первый операнд, выход
		out_operand_2: out std_ulogic_vector((operand_length-1) downto 0); -- второй операнд, выход
		out_val: out std_ulogic_vector( (reg_size-1) downto 0); -- выходное значение
		ram_addr: out std_ulogic_vector( (addr_length-1) downto 0); -- адрес внешней памяти
		ram_val_in: out std_ulogic_vector( (reg_size-1) downto 0); -- данные во внешнюю память
		ram_val_out: in std_ulogic_vector( (reg_size-1) downto 0); -- данные с внешней памяти
		we: out std_logic; -- разрешение на запись в память
		we_flag_reg: out std_logic -- разрешение на запись в регистр
);
end entity conveyor;

architecture conveyor_rtl of conveyor is
signal counter: integer := 0; -- текущее состояние
begin
	process (clk)
		variable now_command : std_ulogic_vector( (command_length - 1) downto 0); -- Код операции
		variable now_operand_1 : std_ulogic_vector( (operand_length - 1) downto 0); -- Операнд 1
		variable now_operand_2 : std_ulogic_vector( (addr_length - 1) downto 0); -- Операнд 2
		variable value_operand_1 : std_ulogic_vector( (reg_size - 1) downto 0); -- Данные операнда 1
		variable value_operand_2 : std_ulogic_vector( (reg_size - 1) downto 0); -- Данные операнда 2
	begin
		if (clk'event and clk = '1') then 
			case counter is
				when 0 => -- выборка команды
					now_command := in_data((command_length + operand_length + addr_length - 1) downto (operand_length + addr_length));
					now_operand_1 := in_data((operand_length + addr_length - 1) downto addr_length);
					now_operand_2 := in_data((addr_length - 1) downto 0);
					counter <= 1;
				when 1 => -- выборка операндов
					case to_integer(unsigned(now_command)) is
						when 0 | 1 => -- add or sub
							-- отправляем запрос на чтение значений из регистров
							out_operand_1 <= now_operand_1;
							out_operand_2 <= now_operand_2((operand_length-1) downto 0);
						when 2 => -- load
							-- отправляем запрос на чтение значения из внешней памяти, второй операнд
							we <= '0';
							ram_addr <= now_operand_2;
						when 3 => -- store
							-- отправляем запрос на чтение значения из регистра, первый операнд
							out_operand_1 <= now_operand_1;
						when others => 
					end case;
					counter <= 2;
				when 2 => -- вычисление результата
					case to_integer(unsigned(now_command)) is
						when 0 => -- add
							value_operand_1 := std_ulogic_vector( unsigned(in_val1) + unsigned(in_val2) );
						when 1 => -- sub
							value_operand_1 := std_ulogic_vector( unsigned(in_val1) - unsigned(in_val2) );
						when 2 => -- load
							-- получаем значение из памяти
							value_operand_1 := ram_val_out;
						when 3 => -- store
							-- получаем значение из регистра первого операнда
							value_operand_1 := in_val1;
							-- получаем адрес в памяти из второго операнда
							value_operand_2 := "000000" & now_operand_2;
						when others => 
					end case;
					counter <= 3;
				when 3 => -- запись результата
					if (to_integer(unsigned(now_command)) = 0 or to_integer(unsigned(now_command)) = 1) then  -- add or sub
							-- пишем значение в регистр первого операнда
							we_flag_reg <= '1';
							out_val <= value_operand_1;
					end if;
					if (to_integer(unsigned(now_command)) = 2) then --load
							-- пишем значение в регистр первого операнда
							we_flag_reg <= '1';
							out_val <= value_operand_1;
					end if;
					if (to_integer(unsigned(now_command)) = 3) then --store
							-- пишем значение из регистра в память
							we<='1';
							ram_addr <= value_operand_2((addr_length - 1) downto 0);
							ram_val_in <= value_operand_1;
					end if;
					-- обнуляем переменные
					we_flag_reg <= '0';
					we <= '0';
	--    		now_command := 0;
	--    		now_operand_1 := 0;
	--    		now_operand_2 := 0;
	--				value_operand_1 := 0;
	--				value_operand_2 := 0;
	--				ram_addr <= 0;
					counter <= 0;
				when others =>
					counter <= 0;
			end case;
		end if;
	end process;
end architecture;

