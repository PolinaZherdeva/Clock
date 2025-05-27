module SettingsModule (
    input  logic clk,
    input  logic rst,

    // Установка будильника
    output logic set_alarm,
    output logic [$clog2(60):0] set_minutes,
    output logic [$clog2(24):0] set_hours
);

    // Чтобы set_alarm был активен только один раз
    logic alarm_set_done;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            alarm_set_done <= 0;
        else if (!alarm_set_done)
            alarm_set_done <= 1;  // Ставим флаг, что установка выполнена
    end

    // Установка на 1:01 (часы:минуты) временный вариант
    assign set_minutes = 40;
    assign set_hours   = 2;
    assign set_alarm   = ~alarm_set_done;  // set_alarm = 1 только при первом такте после сброса

endmodule