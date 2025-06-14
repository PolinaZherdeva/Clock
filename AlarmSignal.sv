module AlarmSignal#(
    parameter ALARM_TIME = 10000000
)(
    input logic clk,
    input logic rst,
	 input logic alarm_trigger,
	 output reg [0:6] alarm_signal
);
	logic [$clog2(ALARM_TIME):0] alarm_counter;
	
     always_ff @(posedge clk) begin
        if (!rst) begin
				alarm_signal[0:6] <= 7'b0000000;
       end else begin
				if (alarm_trigger == 1) begin 
					alarm_counter <= ALARM_TIME;
					alarm_signal[0:6] <= 7'b1111111;
				end
				
				if (alarm_counter > 0) 
				alarm_counter <= alarm_counter - 1;
			   else alarm_signal[0:6] <= 7'b0000000;
		  end	  
    end
endmodule