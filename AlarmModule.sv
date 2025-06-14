module AlarmModule (
    input  logic clk,
    input  logic rst,

    // Текущее время
    input  logic [$clog2(60):0] curr_minutes,
    input  logic [$clog2(24):0] curr_hours,

    // Установка будильника, когда будет модуль настроек
    input  logic set_alarm,  // Сигнал установки будильника

    // Сигнал о срабатывании будильника
    output logic alarm_trigger
	 
	// output reg [17:0] alarm_signal
);

    // Регистр хранения целевого времени будильника
    logic [$clog2(60):0] alarm_minutes;
    logic [$clog2(24):0] alarm_hours;
	 
    // Сохраняем заданное время по сигналу set_alarm
    always_ff @(posedge clk) begin
        if (!rst) begin
            alarm_minutes <= 'x;
            alarm_hours   <= 'x;
       // end else if (set_alarm) begin
            alarm_minutes <= 10;
            alarm_hours   <= 1;
        end

    end

    // Сравнение текущего времени с будильником
    assign alarm_trigger = (curr_minutes == alarm_minutes) && (curr_hours == alarm_hours);

endmodule