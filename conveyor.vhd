-- conveyor
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


component conveyor is 
generic (
	command_length := 2; -- разрядность команды
	operand_length : integer := 4; --разрядность операнда (регистр или память)
	addr_length : integer := 4;
	reg_size: integer := 8;
	counter := 0;
);
port ( --входы и выходы
		clk: in std_logic; --тактирование
		in_data: in std_ulogic_vector( (command_length + operand_length*2 - 1) downto 0)
		in_ram_value: in std_ulogic_vector( (reg_size-1) downto 0);
		in_reg_value: in std_ulogic_vector( (reg_size-1) downto 0);
		out_command: out std_ulogic_vector((command_length-1) downto 0); -- команда на выход
		out_operand_1: out std_logic_vector((operand_length-1) downto 0); -- первый операнд, выход
		out_operand_2: out std_logic_vector((operand_length-1) downto 0); -- второй операнд, выход
		reg_addr: out std_ulogic_vector( (operand_length-1) downto 0);
		reg_value: out std_ulogic_vector( (reg_size-1) downto 0);
		we_flag_reg: out std_logic;
		ram_addr: out std_ulogic_vector( (operand_length-1) downto 0);
		ram_value: out std_ulogic_vector( (reg_size-1) downto 0);
		we_flag_ram: out std_logic;
);
end component;

architecture conveyor_rtl of conveyor is
begin
	process (clk'event and clk='1')
	begin
	--  TODO как проверить конфликт
	    if (counter==0)  -- выборка команды
	        begin
				now_command := in_data(0 to 2);
				now_operand_1 := in_data(2 to 12);
				now_operand_2 := in_data(12 to 22);
	        end
	    if (counter==1) -- выборка операндов
	        begin
				if (now_command==0) --load
					begin
						-- отправляем запрос на чтение значения из внешней памяти
						we_flag_ram<= '0';
						ram_addr<=now_operand_2;
					end
				if (now_command==1) --store
					begin
						-- отправляем запрос на чтение значения из регистра, первый операнд
						we_flag_reg<='0';
						reg_addr<=now_operand_1;
					end
				if (now_command==2 or now_command==3) --sum или mul
					begin
					end
				value_operand_1 := ;
				value_operand_2 := ;
	        end
	    if (counter>=2) -- вычисление
	        begin
	    		if(now_command==0) -- load
        		    begin
        		        out_command<=in_command;
						value_operand_1 := in_ram_value; -- получаем данные из внешней памяти на следующий такт
        		    end
        		if(now_command==1) -- store
        		    begin
						-- получаем значение из регистра первого операнда
        		        out_command<=in_command;
						value_operand_1 := in_reg_value;
						-- отправляем запрос на значение регистра второго операнда
						we_flag_reg<='0';
						reg_addr<=now_operand_2;
        		    end
        		if(now_command==2) -- sum
        		    begin
        		        value_operand_1<=value_operand_1+value_operand_2;
        		        value_operand_2<=0;
        		        out_command<=in_command;
        		    end
        		if(now_command==3) -- mul
        		   begin
        		        if (counter==6) -- производим вычисление на 6-ом такте (то есть умножение выполняем за 4 такта)
        		            begin
        		                value_operand_1<=in_operand_1*in_operand_2;
        		                value_operand_2<=0;
        		                out_command<=in_command;
        		            end
        		        counter:=counter + 1;
        		   end
	        end
	    if (counter==3 or counter==7) -- запись результата
	        begin
				if (now_command==0 or now_command==2 or now_command==3)
					begin
						-- пишем значение в регистр первого операнда
						we_flag_reg<='1';
						write_reg_addr <= std_ulogic_vector(now_operand_1);
						write_reg_value <= std_ulogic_vector(value_operand_1);
					end
				if (now_command==1)
					begin 
						-- получаем значение второго операнда (то есть адрес памяти)
						value_operand_2 := in_reg_value

						-- пишем значение из регистра в память
						we_flag_ram<='1';
						ram_addr<=std_ulogic_vector(value_operand_2);
						ram_value<=std_ulogic_vector(value_operand_1);
					end
				-- обнуляем переменные
				counter := 0;
    			now_command := 0;
    			now_operand_1 := 0;
    			now_operand_2 := 0;
				value_operand_1 := 0;
				value_operand_2 := 0;
				we_flag_reg <= '0';
				we_flag_ram <= '0';
				reg_addr <= 0;
				reg_value <= 0;
				ram_addr <= 0;
				ram_value <= 0;
	        end
	end process;
end architecture;

