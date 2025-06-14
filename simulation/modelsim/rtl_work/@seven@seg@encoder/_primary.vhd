library verilog;
use verilog.vl_types.all;
entity SevenSegEncoder is
    port(
        digit           : in     vl_logic_vector(3 downto 0);
        seg             : out    vl_logic_vector(6 downto 0)
    );
end SevenSegEncoder;
