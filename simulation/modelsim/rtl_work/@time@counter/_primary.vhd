library verilog;
use verilog.vl_types.all;
entity TimeCounter is
    generic(
        MAX_COUNT       : integer := 60
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        inc_tick        : in     vl_logic;
        counter         : out    vl_logic_vector;
        rollover        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MAX_COUNT : constant is 1;
end TimeCounter;
