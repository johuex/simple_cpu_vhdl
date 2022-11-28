--top level vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use conveyor_rtl;
use memory_rtl;
use clk_rtl;

entity main is
generic (
	command_length: integer := 2; 
	operand_length: integer := 10;
);
port (
    we: in std_logic; -- разрешение записи для регистра, всегда будет 1
    reset: in std_logic; -- всегда будет 0
    in_command_1: in std_ulogic_vector((command_length-1) downto 0);
	in_operand_1_1: in std_logic_vector((operand_length-1) downto 0);
	in_operand_2_1: in std_logic_vector((operand_length-1) downto 0);
	
	in_command_2: in std_ulogic_vector((command_length-1) downto 0);
	in_operand_1_2: in std_logic_vector((operand_length-1) downto 0);
	in_operand_2_2: in std_logic_vector((operand_length-1) downto 0);
	
	in_command_3: in std_ulogic_vector((command_length-1) downto 0);
	in_operand_1_3: in std_logic_vector((operand_length-1) downto 0);
	in_operand_2_3: in std_logic_vector((operand_length-1) downto 0);
	
	in_command_4: in std_ulogic_vector((command_length-1) downto 0);
	in_operand_1_4: in std_logic_vector((operand_length-1) downto 0);
	in_operand_2_4: in std_logic_vector((operand_length-1) downto 0);
	
	in_command_5: in std_ulogic_vector((command_length-1) downto 0);
	in_operand_1_5: in std_logic_vector((operand_length-1) downto 0);
	in_operand_2_5: in std_logic_vector((operand_length-1) downto 0);
);
end entity main;

architecture main_rtl of main is
--signal singnal_1:integer ...
component main_comp is
port ();
end component main_comp;

-- описываем внутренние компоненты
begin

	custom_clk:
    	component clk_rtl
		port map(
		    clk=>clk_signal_reg;
   		    clk=>clk_signal_ram;
		    -- clk сигналы на конвееры
			clk=>clk_signal_1;
		    clk=>clk_signal_2;
		    clk=>clk_signal_3;
		    clk=>clk_signal_4;
   		    clk=>clk_signal_5;
		);
	reg_memory:  -- уникальное имя компонента
	    component memory_rtl  -- какой тип компонента используем
		generic map ({addr_length:=4}, {reg_size:=8}, {mem_size:=10});  -- тут заполняем значениями generic параметры
		port map(
	   	    clk=>signal_reg;
	   	    we=>we;
	   	    reset=>;
	   	    addr=>;
	   	    datai=>;
	   	    datao=>;
		); -- тут матчим io

	ram:
	    component memory_rtl
		generic map ({addr_length:=4}, {reg_size:=8}, {mem_size:=10});
		port map();

	conveyor_1:
		component conveyor_rtl
			port map(
		    clk => clk_signal_1;
		    in_command_1=>;
		    in_operand_1_1=>;
		    in_operand_2_1=>;
		
		    -- TODO описать out выходы, если нужны
		    out_command_1=>;
		    out_operand_1_1=>signal_;
		    out_operand_2_1=>;
		);

	conveyor_2:
		component conveyor_rtl
		port map();

	conveyor_3:
		component conveyor_rtl
		port map();

	conveyor_4:
		component conveyor_rtl
		port map();

	conveyor_5:
		component conveyor_rtl
		port map();
		
end architecture struct;

