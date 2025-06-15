module SettingMode(
	 output logic [6:0] seg_hour_tens_3, //HEX3
    output logic [6:0] seg_hour_units_2, //HEX2
    output logic [6:0] seg_min_tens_1, //HEX1
    output logic [6:0] seg_min_units_0, //HEX0
	 
	 input clk,
	 
	 input logic [$clog2(60):0] minutes,
    input logic [$clog2(24):0] hours, 
	 input logic [$clog2(60):0] minutes_settings,
    input logic [$clog2(24):0] hours_settings,
	 
	 input  logic settings_signal
);
	logic [$clog2(60):0] minutes_out;
   logic [$clog2(24):0] hours_out;

	always_ff @(posedge clk) begin
		if (settings_signal == 0) begin
			  minutes_out = minutes;
			  hours_out = hours;
		 end else begin
			  minutes_out = minutes_settings;
			  hours_out = hours_settings;
		 end
	end
	
	Sevensegment sevensegment(
	.seg_min_units_0(seg_min_units_0),
	.seg_min_tens_1(seg_min_tens_1),
	.seg_hour_units_2(seg_hour_units_2),
	.seg_hour_tens_3(seg_hour_tens_3),
	.minutes(minutes_out),
	.hours(hours_out)
	);

endmodule