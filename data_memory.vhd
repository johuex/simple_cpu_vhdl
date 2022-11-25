-- registers
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--описываем память как тип данных (Entity Declaration)
entity memory_d is 
generic ( --определенные значения компонента
	addr_length : integer := 10; --разрядность адреса в битах
	reg_size : integer := 16; -- длина слова памяти в битах
	mem_size: integer := 1024 -- максимальная длина памяти
);
port ( --входы и выходы
		clk: in std_logic; --тактирование
		we: in std_logic; -- разрешение записи
		reset: in std_logic;
		addr: in std_ulogic_vector((addr_length-1) downto 0); --адрес
		datai: in std_logic_vector((reg_size-1) downto 0); --данные для записи в память
		datao: out std_logic_vector((reg_size-1) downto 0) --данные, читаемые из памяти
);
end entity memory_d;

--память как блок в виде массива (Entity architecture)
architecture memory_d_arch of memory_d is
type mem_array is array (0 to mem_size-1) of std_logic_vector((reg_size-1) downto 0);
signal mem_arr: mem_array;

begin
	process (clk, reset)
	begin
	--заполняем память по переднему фронту
		if clk'event and clk='1' then
			if 
				we='1' then mem_arr(conv_integer(unsigned(addr))) <= datai; 
				-- conv_integer = from binary to decimal
			end if;
			--обратно выдаем значение
			datao <= mem_arr(conv_integer(unsigned(addr)));
		end if;
		--сброс
		if reset='1' then
			mem_arr(0) <= x"0000";
		end if;
	end process;
end architecture;
