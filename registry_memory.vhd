library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- registry memory
entity registers is
generic (
	addr_length: integer := 10; -- разрядность адреса памяти в битах, 
	reg_size: integer := 16; -- длина слова памяти в битах, размер ячейки
	mem_size: integer := 10 -- размер памяти, кол-во ячеек памяти
);
port(
	clk : in std_logic;
	reset: in std_logic;
	-- для каждого конвеера:
	-- * we,
	-- * x2 входа, адреса на чтение,
	-- * вход для записи значения в регистр
	-- * x2 выхода, значения регистров
	we_1 : in std_logic;
	rd1_addr_1 : in  std_ulogic_vector((addr_length-1) downto 0);
	rd2_addr_1 : in  std_ulogic_vector((addr_length-1) downto 0);
	wr_data_1  : in std_logic_vector((reg_size-1) downto 0);
	rd1_data_1 : out std_logic_vector((reg_size-1) downto 0);
	rd2_data_1 : out std_logic_vector((reg_size-1) downto 0);
	
	we_2 : in std_logic;
	rd1_addr_2 : in  std_ulogic_vector((addr_length-1) downto 0);
	rd2_addr_2 : in  std_ulogic_vector((addr_length-1) downto 0);
	wr_data_2  : in std_logic_vector((reg_size-1) downto 0);
	rd1_data_2 : out std_logic_vector((reg_size-1) downto 0);
	rd2_data_2 : out std_logic_vector((reg_size-1) downto 0);
	
	we_3 : in std_logic;
	rd1_addr_3 : in  std_ulogic_vector((addr_length-1) downto 0);
	rd2_addr_3 : in  std_ulogic_vector((addr_length-1) downto 0);
	wr_data_3  : in std_logic_vector((reg_size-1) downto 0);
	rd1_data_3 : out std_logic_vector((reg_size-1) downto 0);
	rd2_data_3 : out std_logic_vector((reg_size-1) downto 0);
	
	we_4 : in std_logic;
	rd1_addr_4 : in  std_ulogic_vector((addr_length-1) downto 0);
	rd2_addr_4 : in  std_ulogic_vector((addr_length-1) downto 0);
	wr_data_4  : in std_logic_vector((reg_size-1) downto 0);
	rd1_data_4 : out std_logic_vector((reg_size-1) downto 0);
	rd2_data_4 : out std_logic_vector((reg_size-1) downto 0);
	
	we_5 : in std_logic;
	rd1_addr_5 : in  std_ulogic_vector((addr_length-1) downto 0);
	rd2_addr_5 : in  std_ulogic_vector((addr_length-1) downto 0);
	wr_data_5  : in std_logic_vector((reg_size-1) downto 0);
	rd1_data_5 : out std_logic_vector((reg_size-1) downto 0);
	rd2_data_5 : out std_logic_vector((reg_size-1) downto 0)

);
end entity registers;

architecture registers_rtl of registers is
type regfile_array is array(0 to mem_size) of std_logic_vector(reg_size-1 downto 0);
begin
	process(clk, reset)
		variable registers : regfile_array := (others => (others => '0')); --fill zeros
	begin
		if (clk'event and clk='1') then
				-- write to registers
				if we_1 = '1' then
					registers(to_integer(unsigned(rd1_addr_1))) := wr_data_1;
				end if;
				if we_2 = '1' then
					registers(to_integer(unsigned(rd1_addr_2))) := wr_data_2;
				end if;
				if we_3 = '1' then
					registers(to_integer(unsigned(rd1_addr_3))) := wr_data_3;
				end if;
				if we_4 = '1' then
					registers(to_integer(unsigned(rd1_addr_4))) := wr_data_4;
				end if;
				if we_5 = '1' then
					registers(to_integer(unsigned(rd1_addr_5))) := wr_data_5;
				end if;
				
				-- read registers output
				rd1_data_1 <= registers(to_integer(unsigned(rd1_addr_1)));
				rd2_data_1 <= registers(to_integer(unsigned(rd2_addr_1)));
				rd1_data_2 <= registers(to_integer(unsigned(rd1_addr_2)));
				rd2_data_2 <= registers(to_integer(unsigned(rd2_addr_2)));
				rd1_data_3 <= registers(to_integer(unsigned(rd1_addr_3)));
				rd2_data_3 <= registers(to_integer(unsigned(rd2_addr_3)));
				rd1_data_4 <= registers(to_integer(unsigned(rd1_addr_4)));
				rd2_data_4 <= registers(to_integer(unsigned(rd2_addr_4)));
				rd1_data_5 <= registers(to_integer(unsigned(rd1_addr_5)));
				rd2_data_5 <= registers(to_integer(unsigned(rd2_addr_5)));
			
		end if;
		
		if reset='1' then
			registers(0) := x"0000000000000000";
			registers(1) := x"0000000000000000";
			registers(2) := x"0000000000000000";
			registers(3) := x"0000000000000000";
			registers(4) := x"0000000000000000";
			registers(5) := x"0000000000000000";
			registers(6) := x"0000000000000000";
			registers(7) := x"0000000000000000";
			registers(8) := x"0000000000000000";
			registers(9) := x"0000000000000000";
		end if;
	end process;
end architecture registers_rtl;