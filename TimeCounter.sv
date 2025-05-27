module TimeCounter #(
    parameter MAX_COUNT = 60  //60 минут
)(
    input  logic clk,
    input  logic rst,
    input  logic inc_tick, // входной тик от TickCounter
    output logic [$clog2(MAX_COUNT):0] counter, // счётчик минут
    output logic rollover // сообщаем, что минуты прошли полный цикл и нужно увеличивать счётчик часов
);
    always_ff @(posedge clk) begin
        if (!rst)
            counter <= 0;
        else if (inc_tick) begin
            if (counter == MAX_COUNT - 1)
                counter <= 0;
            else
                counter <= counter + 1;
        end
    end
    // сообщаем, что прошло 60 минут (+ должен быть тик)
    assign rollover = (counter == MAX_COUNT - 1) && inc_tick;
endmodule

