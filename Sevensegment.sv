module Sevensegment(
    input  logic [$clog2(60):0] minutes,
    input  logic [$clog2(24):0] hours,
    output logic [6:0] seg_hour_tens_3, // HEX3
    output logic [6:0] seg_hour_units_2, // HEX2
    output logic [6:0] seg_min_tens_1,   // HEX1
    output logic [6:0] seg_min_units_0   // HEX0
);

    logic [3:0] minutes_unit; 
    logic [3:0] minutes_ten; 
    logic [3:0] hours_unit;
    logic [3:0] hours_ten;
	 

	 DigitSplitter splitMinutes(
		.digit(minutes),
		.units(minutes_unit),
		.tens(minutes_ten)
	 );
    
	  DigitSplitter splitHours(
		.digit(hours),
		.units(hours_unit),
		.tens(hours_ten)
	 );
    

	 //Вывод каждой цифры через семисегментник
	 // Минуты единицы
	 SevenSegEncoder seg_min_units_enc ( 
		.digit(minutes_unit),
		.seg(seg_min_units_0)
	 );
	 // Минуты десятки
	 SevenSegEncoder seg_min_tens_enc (
		.digit(minutes_ten),
		.seg(seg_min_tens_1)
	 );
	 // Часы единицы
	 SevenSegEncoder seg_hour_units_enc (
		.digit(hours_unit),
		.seg(seg_hour_units_2)
	 );
	 // Часы десятки
	 SevenSegEncoder seg_hour_tens_enc (
		.digit(hours_ten),
		.seg(seg_hour_tens_3)
		);
		
endmodule
