library verilog;
use verilog.vl_types.all;
entity SettingsModule is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        set_alarm       : out    vl_logic;
        set_minutes     : out    vl_logic_vector(6 downto 0);
        set_hours       : out    vl_logic_vector(5 downto 0)
    );
end SettingsModule;
