library verilog;
use verilog.vl_types.all;
entity DigitSplitter is
    generic(
        MAX_VALUE       : integer := 59;
        MAX_TENS        : integer := 5;
        MAX_UNITS       : integer := 9
    );
    port(
        value           : in     vl_logic_vector;
        tens            : out    vl_logic_vector;
        \units\         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MAX_VALUE : constant is 1;
    attribute mti_svvh_generic_type of MAX_TENS : constant is 1;
    attribute mti_svvh_generic_type of MAX_UNITS : constant is 1;
end DigitSplitter;
