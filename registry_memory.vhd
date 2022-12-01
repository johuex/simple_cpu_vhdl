library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- registry memory
entity registers is
generic (
	addr_length: integer := 10; -- разрядность адреса памяти в битах, 
	reg_size: integer := 16; -- длина слова памяти в битах, размер ячейки
	mem_size: integer := 1024 -- размер памяти, кол-во ячеек памяти
);
port(
	clk    : in std_logic;

	-- Read port 1:
	rs1_addr : in  std_ulogic_vector((addr_length-1) downto 0);
	rs1_data : out std_logic_vector((reg_size-1) downto 0);

	-- Read port 2:
	rs2_addr : in  std_ulogic_vector((addr_length-1) downto 0);
	rs2_data : out std_logic_vector((reg_size-1) downto 0);

	-- Write port:
	rd_addr  : in std_ulogic_vector((addr_length-1) downto 0);
	rd_data  : in std_logic_vector((reg_size-1) downto 0);
	we : in std_logic
);
end entity registers;

architecture registers_rtl of registers is
type regfile_array is array(0 to 31) of std_logic_vector(31 downto 0);
begin
	process(clk)
		variable registers : regfile_array := (others => (others => '0')); --fill zeros
	begin
		if (clk'event and clk='1') then
				if we = '1' then
					registers(to_integer(unsigned(rd_addr))) := rd_data;
				end if;

				rs1_data <= registers(to_integer(unsigned(rs1_addr)));
				rs2_data <= registers(to_integer(unsigned(rs2_addr)));
		end if;
	end process;
end architecture registers_rtl;