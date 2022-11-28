entity clk_gen is
generic (t:natural:=2 ns);
end entity;

architecture clk_rtl of clk_gen is
signal clk:std_logic:='0';
begin
    process (clk)
    begin
        if clk='0' then
            clk<='11 after t, '0' after 2*t;
        end if;
    end process;
end architecture;

