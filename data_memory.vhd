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
		reset: in std_logic; -- ресет
		
		we_1: in std_logic;                                     	-- разрешение записи
		addr_1: in std_ulogic_vector((addr_length-1) downto 0); 	-- адрес ячейки памяти
		datai_1: in std_ulogic_vector((reg_size-1) downto 0); 	-- данные для записи в память
		datao_1: out std_ulogic_vector((reg_size-1) downto 0); 	-- данные, читаемые из памяти
		flag_idle_1: out std_logic;										-- флаг блокировки конвейера
		
		we_2: in std_logic;                                     	-- разрешение записи
		addr_2: in std_ulogic_vector((addr_length-1) downto 0); 	-- адрес ячейки памяти
		datai_2: in std_ulogic_vector((reg_size-1) downto 0); 	-- данные для записи в память
		datao_2: out std_ulogic_vector((reg_size-1) downto 0); 	-- данные, читаемые из памяти
		flag_idle_2: out std_logic;										-- флаг блокировки конвейера
		
		we_3: in std_logic;                                     	-- разрешение записи
		addr_3: in std_ulogic_vector((addr_length-1) downto 0); 	-- адрес ячейки памяти
		datai_3: in std_ulogic_vector((reg_size-1) downto 0); 	-- данные для записи в память
		datao_3: out std_ulogic_vector((reg_size-1) downto 0); 	-- данные, читаемые из памяти
		flag_idle_3: out std_logic;										-- флаг блокировки конвейера
		
		we_4: in std_logic;                                     	-- разрешение записи
		addr_4: in std_ulogic_vector((addr_length-1) downto 0); 	-- адрес ячейки памяти
		datai_4: in std_ulogic_vector((reg_size-1) downto 0); 	-- данные для записи в память
		datao_4: out std_ulogic_vector((reg_size-1) downto 0); 	-- данные, читаемые из памяти
		flag_idle_4: out std_logic;										-- флаг блокировки конвейера
		
		we_5: in std_logic;                                     	-- разрешение записи
		addr_5: in std_ulogic_vector((addr_length-1) downto 0); 	-- адрес ячейки памяти
		datai_5: in std_ulogic_vector((reg_size-1) downto 0); 	-- данные для записи в память
		datao_5: out std_ulogic_vector((reg_size-1) downto 0); 	-- данные, читаемые из памяти
		flag_idle_5: out std_logic;										-- флаг блокировки конвейера
		
		we_6: in std_logic;                                     	-- разрешение записи
		addr_6: in std_ulogic_vector((addr_length-1) downto 0); 	-- адрес ячейки памяти
		datai_6: in std_ulogic_vector((reg_size-1) downto 0); 	-- данные для записи в память
		datao_6: out std_ulogic_vector((reg_size-1) downto 0); 	-- данные, читаемые из памяти
		flag_idle_6: out std_logic										-- флаг блокировки конвейера
);
end entity memory;

architecture memory_rtl of memory is
type mem_array is array (0 to mem_size-1) of std_ulogic_vector((reg_size-1) downto 0);
signal mem_arr: mem_array;
begin
	process (clk, reset)
	begin
		if (clk'event and clk='1') then
		
			-- conflict resolving
			if (addr_1 = addr_2) then
				flag_idle_2 <= '1';
			else 
				flag_idle_2 <= '0';
			end if;
			if (addr_1 = addr_3 or addr_2 = addr_3) then
				flag_idle_3 <= '1';
			else 
				flag_idle_3 <= '0';
			end if;
			if (addr_1 = addr_4 or addr_2 = addr_4 or addr_3 = addr_4) then
				flag_idle_4 <= '1';
			else 
				flag_idle_4 <= '0';
			end if;
			if (addr_1 = addr_5 or addr_2 = addr_5 or addr_3 = addr_5 or addr_4 = addr_3) then
				flag_idle_5 <= '1';
			else 
				flag_idle_5 <= '0';
			end if;
			if (addr_1 = addr_6 or addr_2 = addr_6 or addr_3 = addr_6 or addr_4 = addr_6 or addr_5 = addr_6) then
				flag_idle_6 <= '1';
			else 
				flag_idle_6 <= '0';
			end if;
			
			if we_1 = '1' then
				mem_arr(conv_integer(unsigned(addr_1))) <= datai_1;
			end if;
			if we_2 = '1' then
				mem_arr(conv_integer(unsigned(addr_2))) <= datai_2;
			end if;
			if we_3 = '1' then
				mem_arr(conv_integer(unsigned(addr_3))) <= datai_3;
			end if;
			if we_4 = '1' then
				mem_arr(conv_integer(unsigned(addr_4))) <= datai_4;
			end if;
			if we_5 = '1' then
				mem_arr(conv_integer(unsigned(addr_5))) <= datai_5;
			end if;
			if we_6 = '1' then
				mem_arr(conv_integer(unsigned(addr_6))) <= datai_6;
			end if;
			--чтение из памяти
			datao_1 <= mem_arr(conv_integer(unsigned(addr_1)));
			datao_2 <= mem_arr(conv_integer(unsigned(addr_1)));
			datao_3 <= mem_arr(conv_integer(unsigned(addr_1)));
			datao_4 <= mem_arr(conv_integer(unsigned(addr_1)));
			datao_5 <= mem_arr(conv_integer(unsigned(addr_1)));
			datao_6 <= mem_arr(conv_integer(unsigned(addr_1)));
		end if;
		if reset='1' then
			mem_arr(0) <= x"0000";
			mem_arr(1) <= x"0010";
			mem_arr(2) <= x"0020";
			mem_arr(3) <= x"0030";
			mem_arr(4) <= x"0040";
			mem_arr(5) <= x"0050";
			mem_arr(6) <= x"0060";
			mem_arr(7) <= x"0070";
		end if;
	end process;
end architecture;
