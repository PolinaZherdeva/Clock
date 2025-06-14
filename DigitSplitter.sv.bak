module DigitSplitter #(
	 parameter MAX_VALUE = 59,
    parameter MAX_TENS = 5, // для десятков максимальное значение 5 (59 - минут/ 23 - часа)
    parameter MAX_UNITS = 9	 // единицы
)
(
	input logic [($clog2(MAX_VALUE)-1):0] value,
	output logic [($clog2(MAX_TENS)-1):0] tens,
	output logic [($clog2(MAX_UNITS)-1):0] units
);

	assign tens = value / 10; // десятки
	assign units = value % 10; // единицы

endmodule