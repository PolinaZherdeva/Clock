module TimeSettings #(
    parameter MAXMIN = 60,
	 parameter MAXHOURS = 24 
)(
	input  logic clk,
   input  logic settings_signal,

	output logic [$clog2(60):0] minutes_settings,
   output logic [$clog2(24):0] hours_settings

);

  always @(posedge clk) begin
	
		if(settings_signal == 1) begin
			minutes_settings = 11;
			hours_settings = 11;
		end
		
	end
endmodule

