--top level vhdl
use library;
use conveyor;

entity main is
port ();
end entity main;

architecture struct of main is
--signal singnal_1:integer ...
component main_comp is
port ();
end component main_comp;

begin
1_conveyor:
	component conveyor
	generic map ();
	port map();
end architecture struct;
