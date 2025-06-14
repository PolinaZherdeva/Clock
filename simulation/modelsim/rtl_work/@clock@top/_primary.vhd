library verilog;
use verilog.vl_types.all;
entity ClockTop is
    generic(
        TICK_COUNT_MAX  : integer := -1294967296
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        minutes         : out    vl_logic_vector(6 downto 0);
        hours           : out    vl_logic_vector(5 downto 0);
        seg_hour_tens_3 : out    vl_logic_vector(6 downto 0);
        seg_hour_units_2: out    vl_logic_vector(6 downto 0);
        seg_min_tens_1  : out    vl_logic_vector(6 downto 0);
        seg_min_units_0 : out    vl_logic_vector(6 downto 0);
        alarm_trigger   : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of TICK_COUNT_MAX : constant is 1;
end ClockTop;
