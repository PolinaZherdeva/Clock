module SevenSegEncoder(
	input logic [3:0] digit, //число от 0 до 9 -> 2^4 бит
	output logic [6:0] seg // выходная двоичная комбинация на семисегментник
);

always_comb begin
	case (digit)
		4'd0: seg = 7'b0000001;
		4'd1: seg = 7'b1001111;
		4'd2: seg = 7'b0010010;
		4'd3: seg = 7'b0000110;
		4'd4: seg = 7'b1001100;
		4'd5: seg = 7'b0100100;
		4'd6: seg = 7'b0100000;
		4'd7: seg = 7'b0001111;
		4'd8: seg = 7'b0000000;
		4'd9: seg = 7'b0000100;
		default: seg = 7'b1111111; //по умолчанию ничего не выводится
	endcase
end

endmodule