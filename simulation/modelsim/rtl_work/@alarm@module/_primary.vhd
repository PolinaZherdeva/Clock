library verilog;
use verilog.vl_types.all;
entity AlarmModule is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        curr_minutes    : in     vl_logic_vector(6 downto 0);
        curr_hours      : in     vl_logic_vector(5 downto 0);
        set_alarm       : in     vl_logic;
        set_minutes     : in     vl_logic_vector(6 downto 0);
        set_hours       : in     vl_logic_vector(5 downto 0);
        alarm_trigger   : out    vl_logic
    );
end AlarmModule;
