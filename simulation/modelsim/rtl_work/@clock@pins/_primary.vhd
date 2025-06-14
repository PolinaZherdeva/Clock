library verilog;
use verilog.vl_types.all;
entity ClockPins is
    port(
        seg_display_0   : out    vl_logic_vector(0 to 6);
        seg_display_1   : out    vl_logic_vector(0 to 6);
        seg_display_2   : out    vl_logic_vector(0 to 6);
        seg_display_3   : out    vl_logic_vector(0 to 6);
        rst             : in     vl_logic;
        clk             : in     vl_logic
    );
end ClockPins;
