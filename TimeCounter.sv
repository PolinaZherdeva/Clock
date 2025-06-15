module TimeCounter #(
    parameter MAX_COUNT = 60  // максимальное количество времени

)(
    input  logic clk,
    input  logic rst,
    input  logic inc_tick, // входной тик от TickCounter
	 
	 input  logic load_new_time,                          // флаг загрузки
    input  logic [$clog2(MAX_COUNT):0] new_value,        // новое значение для загрузки
	 
	 output logic [$clog2(MAX_COUNT):0] counter, //счётчик времени
    output logic rollover // сигнал переполнения
);

    

     always_ff @(posedge clk) begin
        if (!rst)
            counter <= 0;
		  else if (load_new_time)// ХЗЗЗЗ
				counter <= new_value;
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