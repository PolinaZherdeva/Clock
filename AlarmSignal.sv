module AlarmSignal#(
    parameter ALARM_TIME = 10000000
)(
    input logic clk,
    input logic rst,
	 input logic alarm_trigger,
	 output reg [17:0] alarm_signal
);
	logic [$clog2(ALARM_TIME):0] alarm_counter;
	
     always_ff @(posedge clk) begin
       if (!rst) begin
			alarm_signal [17:0] <= 18'b000000000000000000;	
       end else begin
		 if(alarm_trigger == 1) begin
			alarm_signal [17:0] <= 18'b111111111111111111;
			end else begin
			alarm_signal [17:0] <= 18'b000000000000000000;
			end
		  end	  
    end
endmodule