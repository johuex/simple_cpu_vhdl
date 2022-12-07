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
	clk : in std_logic;
	reset: in std_logic;
	-- для каждого конвеера:
	-- * we,
	-- * x2 входа, адреса на чтение,
	-- * вход для записи значения в регистр
	-- * x2 выхода, значения регистров
	-- * выход, что конвеер должен пропустить такт
	we_1 : in std_logic;
	addr_1 : in  std_ulogic_vector((addr_length-1) downto 0);
	wr_data_1  : in std_logic_vector((reg_size-1) downto 0);
	out_data_1 : out std_logic_vector((reg_size-1) downto 0);
	conveyor_idle_1: out std_logic;
	
	we_2 : in std_logic;
	addr_2 : in  std_ulogic_vector((addr_length-1) downto 0);
	wr_data_2  : in std_logic_vector((reg_size-1) downto 0);
	out_data_2 : out std_logic_vector((reg_size-1) downto 0);
	conveyor_idle_2: out std_logic;
	
	we_3 : in std_logic;
	addr_3 : in  std_ulogic_vector((addr_length-1) downto 0);
	wr_data_3  : in std_logic_vector((reg_size-1) downto 0);
	out_data_3 : out std_logic_vector((reg_size-1) downto 0);
	conveyor_idle_3: out std_logic;
	
	we_4 : in std_logic;
	addr_4 : in  std_ulogic_vector((addr_length-1) downto 0);
	wr_data_4  : in std_logic_vector((reg_size-1) downto 0);
	out_data_4 : out std_logic_vector((reg_size-1) downto 0);
	conveyor_idle_4: out std_logic;
	
	we_5 : in std_logic;
	addr_5 : in  std_ulogic_vector((addr_length-1) downto 0);
	wr_data_5  : in std_logic_vector((reg_size-1) downto 0);
	out_data_5 : out std_logic_vector((reg_size-1) downto 0);
	conveyor_idle_5: out std_logic
);
end entity memory;

architecture memory_rtl of memory is
type mem_array is array (0 to mem_size-1) of std_logic_vector((reg_size-1) downto 0);
signal mem_arr: mem_array;
begin
	process (clk, reset)
		variable conveyor_idle_1_var : std_logic;
		variable conveyor_idle_2_var : std_logic;
		variable conveyor_idle_3_var : std_logic;
		variable conveyor_idle_4_var : std_logic;
		variable conveyor_idle_5_var : std_logic;
	begin
		if (clk'event and clk='1') then
			-- обнуляем блокировки каждый такт
			conveyor_idle_1_var := '0';
			conveyor_idle_2_var := '0';
			conveyor_idle_3_var := '0';
			conveyor_idle_4_var := '0';
			conveyor_idle_5_var := '0';
			
			-- conflict resolving
			-- при конфликте запись-чтение, сначала даем записать, потом прочитать
			if (addr_1 = addr_2) then
				 conveyor_idle_1_var := '1';
			end if;
			if (addr_1 = addr_3) then
				conveyor_idle_1_var := '1';
			end if;
			if (addr_1 = addr_4) then
				conveyor_idle_1_var := '1';
			end if;
			if (addr_1 = addr_5) then
				conveyor_idle_1_var := '1';
			end if;
			
			if (addr_2 = addr_1) then
				conveyor_idle_2_var := '1';
			end if;
			if (addr_2 = addr_3) then
				conveyor_idle_2_var := '1';
			end if;
			if (addr_2 = addr_4) then
				conveyor_idle_2_var := '1';
			end if;
			if (addr_2 = addr_5) then
				conveyor_idle_2_var := '1';
			end if;
			
			if (addr_3 = addr_1) then
				conveyor_idle_3_var := '1';
			end if;
			if (addr_3 = addr_2) then
				conveyor_idle_3_var := '1';
			end if;
			if (addr_3 = addr_4) then
				conveyor_idle_3_var := '1';
			end if;
			if (addr_3 = addr_5) then
				conveyor_idle_3_var := '1';
			end if;
			
			if (addr_4 = addr_1) then
				conveyor_idle_4_var := '1';
			end if;
			if (addr_4 = addr_2) then
				conveyor_idle_4_var := '1';
			end if;
			if (addr_4 = addr_3) then
				conveyor_idle_4_var := '1';
			end if;
			if (addr_4 = addr_5) then
				conveyor_idle_4_var := '1';
			end if;
			
			if (addr_5 = addr_1) then
				conveyor_idle_5_var := '1';
			end if;
			if (addr_5 = addr_2) then
				conveyor_idle_5_var := '1';
			end if;
			if (addr_5 = addr_3) then
				conveyor_idle_5_var := '1';
			end if;
			if (addr_5 = addr_4) then
				conveyor_idle_5_var := '1';
			end if;
			
			-- write to RAM
			if we_1 = '1' then
				mem_arr(conv_integer(unsigned(addr_1))) <= wr_data_1;
			end if;
			if we_2 = '1' then
				mem_arr(conv_integer(unsigned(addr_2))) <= wr_data_2;
			end if;
			if we_3 = '1' then
				mem_arr(conv_integer(unsigned(addr_3))) <= wr_data_3;
			end if;
			if we_4 = '1' then
				mem_arr(conv_integer(unsigned(addr_4))) <= wr_data_4;
			end if;
			if we_5 = '1' then
				mem_arr(conv_integer(unsigned(addr_5))) <= wr_data_5;
			end if;
			
			conveyor_idle_1 <= conveyor_idle_1_var;
			conveyor_idle_2 <= conveyor_idle_2_var;
			conveyor_idle_3 <= conveyor_idle_3_var;
			conveyor_idle_4 <= conveyor_idle_4_var;
			conveyor_idle_5 <= conveyor_idle_5_var;
			
			-- read RAM output
			-- не даем считать, если есть блок
			if conveyor_idle_1_var /= '1' then
				out_data_1 <= mem_arr(conv_integer(unsigned(addr_1)));
			end if;
			if conveyor_idle_2_var /= '1' then
				out_data_2 <= mem_arr(conv_integer(unsigned(addr_2)));
			end if;
			if conveyor_idle_3_var /= '1' then
				out_data_3 <= mem_arr(conv_integer(unsigned(addr_3)));
			end if;
			if conveyor_idle_4_var /= '1' then
				out_data_4 <= mem_arr(conv_integer(unsigned(addr_4)));
			end if;
			if conveyor_idle_5_var /= '1' then
				out_data_5 <= mem_arr(conv_integer(unsigned(addr_5)));
			end if;
		end if;
		
		--сброс памяти
		if reset='1' then
			for i in 0 to mem_size-1 loop
				mem_arr(i) <= x"0000";
			end loop;
		end if;
	end process;
end architecture;
