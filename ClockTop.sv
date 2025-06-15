module ClockTop #( 
    parameter TICK_COUNT_MAX = 10000000
)( 
    input  logic clk, // 50 МГц
    input  logic rst,
	 
	 // сигнал настройки будильника
	 input logic settings_signal,

    // Текущее время
	 output logic [$clog2(60):0] minutes,
    output logic [$clog2(24):0] hours,
	 
	 // Текущее время
	 output logic [$clog2(60):0] minutes_settings,
    output logic [$clog2(24):0] hours_settings,
	 
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
	 
	 //Настройки времени
	 TimeSettings #(
		.MAXMIN(60),
		.MAXHOURS(24)
	 ) timeSettings (
	 .clk(clk),
	 .settings_signal(settings_signal),
	 .minutes_settings(minutes_settings),
	 .hours_settings(hours_settings)
	 );
	 
	 SettingMode settingMode(
		.clk,
		.seg_min_units_0(seg_min_units_0),
		.seg_min_tens_1(seg_min_tens_1),
		.seg_hour_units_2(seg_hour_units_2),
		.seg_hour_tens_3(seg_hour_tens_3),
		.minutes(minutes),
		.hours(hours),
		.minutes_settings(minutes_settings),
		.hours_settings(hours_settings),
		.settings_signal(settings_signal)
	);

endmodule 