module ClockTop #(
    parameter TICK_COUNT_MAX = 3000000000
)( 
    input  logic clk, // 50 МГц
    input  logic rst,

    // Текущее время
    output logic [$clog2(60):0] minutes,
    output logic [$clog2(24):0] hours,

    // Сигнал срабатывания будильника
    output logic alarm_trigger
);

    // Сигнал тика раз в минуту
    logic minute_tick;

    // Тик при переполнении минут (раз в час)
    logic hour_tick;

    // Сигналы для установки будильника, которые будут генерироваться в SettingsModule
    logic set_alarm;
    logic [$clog2(60):0] set_minutes;
    logic [$clog2(24):0] set_hours;

    // Модуль: счётчик тиков — 1 тик в минуту
    TickCounter #(
        .TICK_COUNT_MAX(TICK_COUNT_MAX)
    ) tick_counter (
        .clk(clk),
        .rst(rst),
        .tick(minute_tick)
    );

    // Модуль: счётчик минут (от 0 до 59)
    TimeCounter #(
        .MAX_COUNT(60)
    ) minute_counter (
        .clk(clk),
        .rst(rst),
        .inc_tick(minute_tick),
        .counter(minutes),
        .rollover(hour_tick)
    );

    // Модуль: счётчик часов (от 0 до 23)
    TimeCounter #(
        .MAX_COUNT(24)
    ) hour_counter (
        .clk(clk),
        .rst(rst),
        .inc_tick(hour_tick),
        .counter(hours)
    );

    // Модуль: настройки будильника (встроенный)
    SettingsModule settings (
        .clk(clk),
        .rst(rst),
        .set_alarm(set_alarm),
        .set_minutes(set_minutes),
        .set_hours(set_hours)
    );

    // Модуль: будильник
    AlarmModule alarm (
        .clk(clk),
        .rst(rst),
        .curr_minutes(minutes),
        .curr_hours(hours),
        .set_alarm(set_alarm),
        .set_minutes(set_minutes),
        .set_hours(set_hours),
        .alarm_trigger(alarm_trigger)
    );

endmodule
