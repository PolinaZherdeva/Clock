module TimeCounter #(
    parameter MAX_COUNT = 60  // максимальное количество времени

)(
    input  logic clk,
    input  logic rst,
    input  logic inc_tick, // входной тик от TickCounter
	 
	 output logic [$clog2(MAX_COUNT):0] counter, //счётчик времени

    output logic [$clog2(10):0] counter_out_unit, // значение для семисегментника единиц
	 output logic [$clog2(10):0] counter_out_ten, // значение для семисегментника десятков
    output logic rollover // сигнал переполнения
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