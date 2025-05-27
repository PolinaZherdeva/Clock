`timescale 1ns/1ps

module ClockTop_tb;

    // Порты топ-модуля
    logic clk;
    logic rst;
    logic [$clog2(60):0] minutes;
    logic [$clog2(24):0] hours;
    logic alarm_trigger;

    // Подключение тестируемого модуля
    ClockTop #(
        .TICK_COUNT_MAX(2)  // 2 такта = 1 минута (для ускоренного теста)
    ) dut (
        .clk(clk),
        .rst(rst),
        .minutes(minutes),
        .hours(hours),
        .alarm_trigger(alarm_trigger)
    );

    // Генерация тактового сигнала
    initial clk = 0;
    always #5 clk = ~clk;  // Период 10 нс (100 МГц)

    // Тестовая логика
    initial begin
        // Инициализация
        rst = 0;
        #20;
        rst = 1;

        // Ждём
        #4000;

        $display("FINISHED");
        $stop;
    end

    // Мониторинг времени и сигнала будильника
    always_ff @(posedge clk) begin
        if (rst) begin
            $display("Time: %0t ns | Minutes: %0d | Hours: %0d | Alarm: %0b", $time, minutes, hours, alarm_trigger);

            if (alarm_trigger) begin
                $display(">>> ALARM TRIGGERED at %0t ns <<<", $time);
            end
        end
    end

endmodule