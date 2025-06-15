`define v1_2 "-name IO_STANDARD \"1.2-V\""
`define v3_3 "-name IO_STANDARD \"3.3-V\""

`define pins_hex0 "V19, V18, V17, W18, Y20, Y19, Y18"

`define pins_hex1 "AA18, AD26, AB19, AE26, AE25, AC19, AF24" 
`define pins_hex2 "AD7, AD6, U20, V22, V20, W21, W20"
`define pins_hex3 "Y24, Y23, AA23, AA22, AC24, AC23, AC22"


module ClockPins(
	(* altera_atribute = `v1_2, chip_pin = `pins_hex0 *) output [6:0]  seg_display_0,
	(* altera_atribute = `v1_2, chip_pin = `pins_hex1 *) output [6:0]  seg_display_1,
	(* altera_atribute = `v3_3, chip_pin = `pins_hex2 *) output [6:0]  seg_display_2,
	(* altera_atribute = `v3_3, chip_pin = `pins_hex3 *) output [6:0]  seg_display_3, 
	(* chip_pin = "F7, F6, G6, G7, J8, J7, K10, K8, H7, J10, L7, K6, D8, E9, A5, B6, H8, H9" *) output[17:0] leds,
	(* altera_atribute = `v1_2, chip_pin = "AE19" *) input rst,
	 //кнопки изменения значения времени
	(* altera_atribute = `v1_2, chip_pin = "P11" *) input dec_min_btn,
	(* altera_atribute = `v1_2, chip_pin = "P12" *) input incr_min_btn,
	(* altera_atribute = `v1_2, chip_pin = "Y15" *) input dec_hour_btn,
	(* altera_atribute = `v1_2, chip_pin = "Y16" *) input incr_hour_btn,
	//switches
	(* altera_atribute = `v1_2, chip_pin = "AC9" *) input time_mode_switch,
	(* altera_atribute = `v1_2, chip_pin = "AE10" *) input alarm_mode_switch,
	(* altera_atribute = `v1_2, chip_pin = "AD13" *) input min_select_switch,
	(* altera_atribute = `v1_2, chip_pin = "AC8" *) input hour_select_switch,
	//clk
	(* chip_pin = "H12" *) input clk
);

ClockTop ClockTop(
	.rst(rst),
	.clk(clk),
	
	//Управление
	.inc_min(inc_min),
   .dec_min(dec_min),
   .inc_hour(inc_hour),
   .dec_hour(dec_hour),
   .min_select(min_select),
   .hour_select(hour_select),
   .set_mode(set_mode),
   .alarm_mode_switch(alarm_mode_switch),
	
	//Сегменты
	.seg_min_units_0(seg_display_0),
	.seg_min_tens_1(seg_display_1),
	.seg_hour_units_2(seg_display_2),
	.seg_hour_tens_3(seg_display_3),
	.alarm_signal(leds)

);


endmodule