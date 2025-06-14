`define v1_2 "-name IO_STANDARD \"1.2-V\""
`define v3_3 "-name IO_STANDARD \"3.3-V\""

`define pins_hex0 "V19, V18, V17, W18, Y20, Y19, Y18"

`define pins_hex1 "AA18, AD26, AB19, AE26, AE25, AC19, AF24" 
`define pins_hex2 "AD7, AD6, U20, V22, V20, W21, W20"
`define pins_hex3 "Y24, Y23, AA23, AA22, AC24, AC23, AC22"


module ClockPins(
(* altera_atribute = `v1_2, chip_pin = `pins_hex0 *) output [0:6]  seg_display_0,
(* altera_atribute = `v1_2, chip_pin = `pins_hex1 *) output [0:6]  seg_display_1,
(* altera_atribute = `v3_3, chip_pin = `pins_hex2 *) output [0:6]  seg_display_2,
(* altera_atribute = `v3_3, chip_pin = `pins_hex3 *) output [0:6]  seg_display_3, 
(* altera_atribute = "-name IO_STANDARD\"1.2-V\"", chip_pin = "P11" *) input rst,
(* chip_pin = "H12" *) input clk
);

ClockTop ClockTop(
.rst(rst),
.clk(clk),
.seg_min_units_0(seg_display_0),
.seg_min_tens_1(seg_display_1),
.seg_hour_units_2(seg_display_2),
.seg_hour_tens_3(seg_display_3)
);


endmodule