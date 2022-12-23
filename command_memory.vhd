
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- ROM memory
entity memory_c is
generic (
	addr_length: integer := 10; -- разрядность адреса памяти в битах,
	reg_size: integer := 16; -- длина команды
	mem_size: integer := 256 -- длина памяти (число команд в памяти)
);
port(
	clk: in std_logic; --тактирование
	reset: in std_logic; -- ресет
	addr: in std_logic_vector((addr_length-1) downto 0); --адрес ячейки памяти
	datao: out std_logic_vector((reg_size-1) downto 0) --данные, читаемые из памяти (команда)
);
end entity memory_c;

architecture memory_c_rtl of memory_c is
type mem_array is array (0 to mem_size-1) of std_logic_vector((reg_size-1) downto 0);
signal mem_arr: mem_array;
begin
	process (clk, reset)
	begin
		if (clk'event and clk='1') then
			--чтение из памяти
			datao <= mem_arr(conv_integer(unsigned(addr)));
		end if;
		if reset='1' then
		-- Записываем набор команд для процессора
		-- TODO придумать свой набор команд с конфликтом
			mem_arr(0) <= "10000000000000"; -- LOAD r0 00000000
			mem_arr(1) <= "10001000000010"; -- LOAD r1 00000010
			mem_arr(2) <= "00001100000100"; -- ADD r3, r4
			mem_arr(3) <= "10001100000000"; -- LOAD r3 00000000
			mem_arr(4) <= "01010100000100"; -- SUB r5, r4
			mem_arr(5) <= "00011000000100"; -- ADD r6, r4
			mem_arr(6) <= "11011100000001"; -- STORE r7 00000001
			mem_arr(7) <= "11000000000000"; -- STORE r0 00000000
		end if;
	end process;
end architecture;