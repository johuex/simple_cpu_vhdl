--top level vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use conveyor;
use memory;
use clk_gen;

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
	
end entity main;

architecture main_rtl of main is
--signal singnal_1:integer ...
component main_comp is
port ();
end component main_comp;

-- описываем внутренние компоненты
begin
registries:  -- уникальное имя компонента
    component memory  -- какой тип компонента используем
	generic map ({addr_length:=2}, {reg_size:=5}, {mem_size:=10});  -- тут заполняем значениями generic параметры
	port map(
   	    clk=>signal_reg;
   	    we=>we;
   	    reset=>;
   	    addr=>;
   	    datai=>;
   	    datao=>;
	); -- тут матчим io

ram:
    component memory
	generic map ({addr_length:=2}, {reg_size:=5}, {mem_size:=10});
	port map();

custom_clk:
    component clk_gen
	port map(
	    clk=>clk_signal_reg;
   	    clk=>clk_signal_ram;
	    clk=>clk_signal_1;
	    clk=>clk_signal_2;
	    clk=>clk_signal_3;
	    clk=>clk_signal_4;
   	    clk=>clk_signal_5;
	);

1_conveyor:
	component conveyor
	port map(
	    clk => clk_signal_1;
	    in_command_1=>;
	    in_operand_1_1=>;
	    in_operand_2_1=>;
	    
	    -- TODO описать out выходы, если нужны
	    out_command_1=>;
	    out_operand_1_1=>;
	    out_operand_2_1=>;
	);

2_conveyor:
	component conveyor
	port map();

3_conveyor:
	component conveyor
	port map();

4_conveyor:
	component conveyor
	port map();

5_conveyor:
	component conveyor
	port map();
	
end architecture struct;

