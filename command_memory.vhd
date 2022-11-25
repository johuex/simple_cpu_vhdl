library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--USE IEEE.numeric_std.ALL;

-- память команд, ROM
entity memory_c is
port(
	data_bus_out: out std_logic_vector(22 downto 0); --выдача команды в ?? виде
	address_bus: in std_logic_vector(22 downto 0); --команда в битовом виде
	nMemRd: in std_logic);  --всегда 0, чтобы прочитать ее
end memory_c;

architecture rom_arch of memory_c is
	signal out_byte: std_logic_vector(31 downto 0);
begin
	init_commend_memory: process(nMemRd)
	begin
		if nMemRd = ’1’ then
		
		end if;
	end process;
	
	
	process(nMemRd)
	begin
	if nMemRd = ’0’ then
		case address_bus is
			when "00" => out_byte <= LOAD;
			when "01" => out_byte <= STORE;
			when "10" => out_byte <= SUM;
			when "11" => out_byte <= MUL;
			when others => out_byte <= (others => ’Z’);
		end case;
	else
		out_byte <= (others => ’Z’);
	end if;
	end process;

data_bus_out <= out_byte;

end architecture;
