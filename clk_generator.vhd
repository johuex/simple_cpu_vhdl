library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Clock generator
entity clk_generator is 
generic (
	t: time := 2ns
);
port (
		clk_out: out std_logic
);
end entity clk_generator;

architecture clk_generator_rtl of clk_generator is
signal clk: std_logic := '0';
begin
	process (clk)
	begin
		if clk = '0' then
			clk <= '1' after t, '0' after 2*t;
		end if;
		clk_out <= clk;
	end process;
end architecture;