-- conveyor
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


component conveyor is 
generic (
	command_length := 2; -- разрядность команды
	operand_length : integer := 10; --разрядность операнда (регистр или память)
	counter := 0;
);
port ( --входы и выходы
		clk: in std_logic; --тактирование
		in_command: in std_ulogic_vector((command_length-1) downto 0); -- команда на вход
		in_operand_1: in std_logic_vector((operand_length-1) downto 0); -- первый операнд, вход
		in_operand_2: in std_logic_vector((operand_length-1) downto 0); -- -- второй операнд, вход
		out_command: out std_ulogic_vector((command_length-1) downto 0); -- команда на выход
		out_operand_1: out std_logic_vector((operand_length-1) downto 0); -- первый операнд, выход
		out_operand_2: out std_logic_vector((operand_length-1) downto 0); -- второй операнд, выход
);
end component;

architecture conveyor_rtl of conveyor is
begin
	process (clk'event and clk='1')
	begin
	-- TODO возможно использовать локальные переменные, а не только входы и выходы
	--  TODO как проверить конфликт
	    if(in_command==0) -- TODO load
            begin
                out_command<=in_command;
            end
        if(in_command==1) -- TODO store
            begin
                out_command<=in_command;
            end
        if(in_command==2) -- sum
            begin
                out_operand_1<=in_operand_1+in_operand_2;
                out_operand_2<=0;
                out_command<=in_command;
            end
        if(in_command==3) -- mul
           begin
                if (counter==3) -- производим вычисление на 4-ом такте
                    begin
                        out_operand_1<=in_operand_1*in_operand_2;
                        out_operand_2<=0;
                        out_command<=in_command;
                    end
                counter:=counter + 1;
           end      
    counter := 0;
	end process;
end architecture;

