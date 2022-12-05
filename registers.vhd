library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Register block
entity registers is 
generic (
	addr_length: integer := 4; -- разрядность адреса регистра, 
	reg_size: integer := 16; -- размер регистра
	reg_count: integer := 8 -- кол-во регистров
);
port (
		clk: in std_logic; --тактирование
		reset: in std_logic; -- ресет
		
		-- Для каждого конвейера
		we_1: in std_logic; -- разрешение записи
		addr1_1: in std_ulogic_vector((addr_length-1) downto 0);
		addr2_1: in std_ulogic_vector((addr_length-1) downto 0);
		datai_1: in std_ulogic_vector((reg_size-1) downto 0);
		datao1_1: out std_ulogic_vector((reg_size-1) downto 0);
		datao2_1: out std_ulogic_vector((reg_size-1) downto 0);
		
		we_2: in std_logic;
		addr1_2: in std_ulogic_vector((addr_length-1) downto 0);
		addr2_2: in std_ulogic_vector((addr_length-1) downto 0);
		datai_2: in std_ulogic_vector((reg_size-1) downto 0);
		datao1_2: out std_ulogic_vector((reg_size-1) downto 0);
		datao2_2: out std_ulogic_vector((reg_size-1) downto 0);
		
		we_3: in std_logic;
		addr1_3: in std_ulogic_vector((addr_length-1) downto 0);
		addr2_3: in std_ulogic_vector((addr_length-1) downto 0);
		datai_3: in std_ulogic_vector((reg_size-1) downto 0);
		datao1_3: out std_ulogic_vector((reg_size-1) downto 0);
		datao2_3: out std_ulogic_vector((reg_size-1) downto 0);
		
		we_4: in std_logic;
		addr1_4: in std_ulogic_vector((addr_length-1) downto 0);
		addr2_4: in std_ulogic_vector((addr_length-1) downto 0);
		datai_4: in std_ulogic_vector((reg_size-1) downto 0);
		datao1_4: out std_ulogic_vector((reg_size-1) downto 0);
		datao2_4: out std_ulogic_vector((reg_size-1) downto 0);
		
		we_5: in std_logic;
		addr1_5: in std_ulogic_vector((addr_length-1) downto 0);
		addr2_5: in std_ulogic_vector((addr_length-1) downto 0);
		datai_5: in std_ulogic_vector((reg_size-1) downto 0);
		datao1_5: out std_ulogic_vector((reg_size-1) downto 0);
		datao2_5: out std_ulogic_vector((reg_size-1) downto 0);
		
		we_6: in std_logic;
		addr1_6: in std_ulogic_vector((addr_length-1) downto 0);
		addr2_6: in std_ulogic_vector((addr_length-1) downto 0);
		datai_6: in std_ulogic_vector((reg_size-1) downto 0);
		datao1_6: out std_ulogic_vector((reg_size-1) downto 0);
		datao2_6: out std_ulogic_vector((reg_size-1) downto 0)
);
end entity registers;

architecture registers_rtl of registers is
type reg_array is array (0 to reg_count-1) of std_ulogic_vector((reg_size-1) downto 0);
signal regs: reg_array;
begin
	process (clk, reset)
	begin
		if (clk'event and clk='1') then
		
			if we_1 = '1' then
				regs(conv_integer(unsigned(addr1_1))) <= datai_1;
			end if;
			if we_2 = '1' then
				regs(conv_integer(unsigned(addr1_2))) <= datai_2;
			end if;
			if we_3 = '1' then
				regs(conv_integer(unsigned(addr1_3))) <= datai_3;
			end if;
			if we_4 = '1' then
				regs(conv_integer(unsigned(addr1_4))) <= datai_4;
			end if;
			if we_5 = '1' then
				regs(conv_integer(unsigned(addr1_5))) <= datai_5;
			end if;
			if we_6 = '1' then
				regs(conv_integer(unsigned(addr1_6))) <= datai_6;
			end if;
			
			datao1_1 <= regs(conv_integer(unsigned(addr1_1)));
			datao2_1 <= regs(conv_integer(unsigned(addr2_1)));
			datao1_2 <= regs(conv_integer(unsigned(addr1_2)));
			datao2_2 <= regs(conv_integer(unsigned(addr2_2)));
			datao1_3 <= regs(conv_integer(unsigned(addr1_3)));
			datao2_3 <= regs(conv_integer(unsigned(addr2_3)));
			datao1_4 <= regs(conv_integer(unsigned(addr1_4)));
			datao2_4 <= regs(conv_integer(unsigned(addr2_4)));
			datao1_5 <= regs(conv_integer(unsigned(addr1_5)));
			datao2_5 <= regs(conv_integer(unsigned(addr2_5)));
			datao1_6 <= regs(conv_integer(unsigned(addr1_6)));
			datao2_6 <= regs(conv_integer(unsigned(addr2_6)));
		end if;
		
		if reset='1' then
			regs(0) <= x"0002";
			regs(1) <= x"0004";
			regs(2) <= x"0003";
			regs(3) <= x"0001";
			regs(4) <= x"0005";
			regs(5) <= x"0010";
			regs(6) <= x"0001";
			regs(7) <= x"0001";
		end if;
	end process;
end architecture;
