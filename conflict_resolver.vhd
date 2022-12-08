library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Resolve RAM conflicts
entity conflict_resolver is 
generic (
	command_length: integer := 2;
	operand_length: integer := 4;
	addr_length: integer := 4;
	reg_size: integer := 16
);
port (
		clk: in std_logic;
		reset: in std_logic;
		-- входные команды для конвееров
		in_data_1: in std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
		in_data_2: in std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
		in_data_3: in std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
		in_data_4: in std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);
		in_data_5: in std_logic_vector((command_length + operand_length + addr_length - 1) downto 0);

		-- флаги для блокировки конвейера
		flag_idle_1: out std_logic;
		flag_idle_2: out std_logic;
		flag_idle_3: out std_logic;
		flag_idle_4: out std_logic;
		flag_idle_5: out std_logic									
);
end entity conflict_resolver;

architecture conflict_resolver_rtl of conflict_resolver is
signal addr_1: std_logic_vector((addr_length-1) downto 0);
signal addr_2: std_logic_vector((addr_length-1) downto 0);
signal addr_3: std_logic_vector((addr_length-1) downto 0);
signal addr_4: std_logic_vector((addr_length-1) downto 0);
signal addr_5: std_logic_vector((addr_length-1) downto 0);

signal we_1: std_logic;
signal we_2: std_logic;
signal we_3: std_logic;
signal we_4: std_logic;
signal we_5: std_logic;

begin
	process (clk, reset)
	begin
		if (clk'event and clk='1') then
			addr_1 <= in_data_1((addr_length - 1) downto 0);
			addr_2 <= in_data_2((addr_length - 1) downto 0);
			addr_3 <= in_data_3((addr_length - 1) downto 0);
			addr_4 <= in_data_4((addr_length - 1) downto 0);
			addr_5 <= in_data_5((addr_length - 1) downto 0);
			if (in_data_1((command_length + operand_length + addr_length - 1) downto (operand_length + addr_length)) = "01") then
				we_1 <= '1';
			else
				we_1 <= '0';
			end if;
			if (in_data_2((command_length + operand_length + addr_length - 1) downto (operand_length + addr_length)) = "01") then
				we_2 <= '1';
			else
				we_2 <= '0';
			end if;
			if (in_data_3((command_length + operand_length + addr_length - 1) downto (operand_length + addr_length)) = "01") then
				we_3 <= '1';
			else
				we_3 <= '0';
			end if;
			if (in_data_4((command_length + operand_length + addr_length - 1) downto (operand_length + addr_length)) = "01") then
				we_4 <= '1';
			else
				we_4 <= '0';
			end if;
			if (in_data_5((command_length + operand_length + addr_length - 1) downto (operand_length + addr_length)) = "01") then
				we_5 <= '1';
			else
				we_5 <= '0';
			end if;
			
			-- conflict resolving
			-- делаем приоритет конвеерам
			flag_idle_1 <= '0';
			if (addr_1 = addr_2 and we_1 = '1') then
				flag_idle_2 <= '1';
			else 
				flag_idle_2 <= '0';
			end if;
			if ((addr_1 = addr_3 and we_1 = '1') or (addr_2 = addr_3 and we_2 = '1')) then
				flag_idle_3 <= '1';
			else 
				flag_idle_3 <= '0';
			end if;
			if ((addr_1 = addr_4 and we_1 = '1') or (addr_2 = addr_4 and we_2 = '1') or (addr_3 = addr_4 and we_3 = '1')) then
				flag_idle_4 <= '1';
			else 
				flag_idle_4 <= '0';
			end if;
			if ((addr_1 = addr_5 and we_1 = '1') or (addr_2 = addr_5 and we_2 = '1') or (addr_3 = addr_5 and we_3 = '1') or (addr_4 = addr_3 and we_4 = '1')) then
				flag_idle_5 <= '1';
			else 
				flag_idle_5 <= '0';
			end if;

		end if;
		if reset='1' then
			flag_idle_1 <= '1';
			flag_idle_2 <= '1';
			flag_idle_3 <= '1';
			flag_idle_4 <= '1';
			flag_idle_5 <= '1';
		end if;
	end process;
end architecture;
