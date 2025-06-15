module ClockTop #( 
    parameter TICK_COUNT_MAX = 10000000
)( 
    input  logic clk, // 50 МГц
    input  logic rst,
	 
	 // сигнал настройки будильника
	 //input logic settings_signal,
	 input logic time_mode_switch,
	 input logic alarm_mode_switch,
	 
	 input logic min_tens_switch, //0 - единицы, 1 - десятки
	 input logic hours_tens_switch,
	 
	 //сохранение значения
	 input logic save_switch,
	 // Кнопки
	 input logic inc_min_btn,
	 input logic dec_min_btn,
	 input logic inc_hour_btn,
	 input logic dec_hour_btn,

    // Текущее время
	 output logic [$clog2(60):0] minutes,
    output logic [$clog2(24):0] hours,
	 
	 // Сигнал изменения времени
	 output logic set_new_time,
	 
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
		  .load_new_time(set_new_time),//
        .new_value(minutes_settings),//
		  .counter(minutes),
        .rollover(hour_tick)
    );


	// Модуль: счётчик часов (от 0 до 23)
    TimeCounter #(
        .MAX_COUNT(24)
    ) hour_counter (
        .clk(clk),
        .rst(rst),
		  .load_new_time(set_new_time),//
        .new_value(hours_settings),//
		  .counter(hours),
        .inc_tick(hour_tick)
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
//	 TimeSettings #(
//		.MAXMIN(60),
//		.MAXHOURS(24)
//	 ) timeSettings (
//	 .clk(clk),
//	 .settings_signal(settings_signal),
//	 .minutes_settings(minutes_settings),
//	 .hours_settings(hours_settings)
//	 );

	//Настройка времени
	SettingsController #(
		.MAX_MINUTES(60),
	   .MAX_HOURS(24)
	) controller (
	.clk(clk),
	.rst(rst),
	.cur_minutes(minutes),
	.cur_hours(hours),
	// switches
	.time_mode_switch(time_mode_switch),
	.alarm_mode_switch(alarm_mode_switch),
	.save_switch(save_switch),
	.min_tens_switch(min_tens_switch),
	.hours_tens_switch(hours_tens_switch),
	// кнопки
	.inc_min_btn(inc_min_btn),
	.dec_min_btn(dec_min_btn),
	.inc_hour_btn(inc_hour_btn),
	.dec_hour_btn(dec_hour_btn),
	
	// сигнал изменения времени
	.set_time(set_new_time),
	
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
		.settings_signal(time_mode_switch)
	);

endmodule 