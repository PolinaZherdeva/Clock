ClockTop #( 
    parameter TICK_COUNT_MAX = 10000000
)( 
    input  logic clk, // 50 МГц
    input  logic rst,

    // Текущее время
	 output logic [$clog2(60):0] minutes,
    output logic [$clog2(24):0] hours,
	 
    output logic [$clog2(60):0] minutes_unit, 
	 output logic [$clog2(60):0] minutes_ten, 
	
    output logic [$clog2(24):0] hours_unit,
    output logic [$clog2(24):0] hours_ten,
	 
	 output logic [6:0] seg_hour_tens_3, //HEX3
    output logic [6:0] seg_hour_units_2, //HEX2
    output logic [6:0] seg_min_tens_1, //HEX1
    output logic [6:0] seg_min_units_0, //HEX0
    // Сигнал срабатывания будильника
    output logic alarm_trigger,
	 output reg [17:0] alarm_signal
);

    // Сигнал тика раз в минуту
    logic minute_tick;

    // Тик при переполнении минут (раз в час)
    logic hour_tick;

	
	
    // Модуль: счётчик тиков — 1 тик в минуту
    TickCounter #(
        .TICK_COUNT_MAX(TICK_COUNT_MAX)
    ) tick_counter (
        .clk(clk),
        .rst(rst),
        .tick(minute_tick),
    );
	 
    // Модуль: счётчик минут (от 0 до 59)
    TimeCounter #(
        .MAX_COUNT(60)
    ) minute_counter (
        .clk(clk),
        .rst(rst),
        .inc_tick(minute_tick),
		  .counter(minutes),
        .counter_out_unit(minutes_unit),
		  .counter_out_ten(minutes_ten),
        .rollover(hour_tick)
    );


	// Модуль: счётчик часов (от 0 до 23)
    TimeCounter #(
        .MAX_COUNT(24)
    ) hour_counter (
        .clk(clk),
        .rst(rst),
		  .counter(hours),
        .inc_tick(hour_tick),
        .counter_out_unit(hours_unit),
		  .counter_out_ten(hours_ten)
    );

	 
	 //Будильник
	 
	 AlarmModule alarmModule (
	 .clk(clk),
	 .rst(rst),
	 .curr_minutes(minutes),
	 .curr_hours(hours),
	 .alarm_trigger(alarm_trigger)
	 );
	 
	 AlarmSignal alarmSignal (
	 .clk(clk),
	 .rst(rst),
	 .alarm_trigger(alarm_trigger),
	 .alarm_signal(alarm_signal)
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