library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- RAM memory
entity memory is 
generic (
	addr_length: integer := 10; -- разрядность адреса памяти в битах, 
	reg_size: integer := 16; -- длина слова памяти в битах, размер ячейки
	mem_size: integer := 1024 -- размер памяти, кол-во ячеек памяти
);
port (
		clk: in std_logic; --тактирование
		we: in std_logic; -- разрешение записи
		reset: in std_logic; -- ресет
		addr: in std_ulogic_vector((addr_length-1) downto 0); --адрес ячейки памяти
		datai: in std_ulogic_vector((reg_size-1) downto 0); --данные для записи в память
		datao: out std_ulogic_vector((reg_size-1) downto 0) --данные, читаемые из памяти
);
end entity memory;

architecture memory_rtl of memory is
type mem_array is array (0 to mem_size-1) of std_ulogic_vector((reg_size-1) downto 0);
signal mem_arr: mem_array;
begin
	process (clk, reset)
	begin
		if (clk'event and clk='1') then
			if we = '1' then
				mem_arr(conv_integer(unsigned(addr))) <= datai; --запись в память
			end if;
			--чтение из памяти
			datao <= mem_arr(conv_integer(unsigned(addr)));
		end if;
		--сброс памяти (дописать. Сейчас сброс только первой ячейки)
		if reset='1' then
			mem_arr(0) <= x"0002";
			mem_arr(1) <= x"0004";
			mem_arr(2) <= x"0003";
			mem_arr(3) <= x"0001";
		end if;
	end process;
end architecture;
