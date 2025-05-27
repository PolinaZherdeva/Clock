module TickCounter #(
    parameter TICK_COUNT_MAX = 3000000000  // Кол-во тактов для одного тика, частота 50 Мгц
)(
    input  logic clk,
    input  logic rst, // Сброс
    output logic tick  // Импульс один такт
);

    // $clog2 — логарифм по основанию 2, чтобы хватило бит на хранение числа TICK_COUNT_MAX
    logic [$clog2(TICK_COUNT_MAX):0] counter;

    always_ff @(posedge clk) begin
        if (!rst)
            counter <= 0;
        else if (counter == TICK_COUNT_MAX - 1)
            counter <= 0;
        else
            counter <= counter + 1;
    end
	
	 // tick = 1, когда counter == TICK_COUNT_MAX - 1
    assign tick = (counter == TICK_COUNT_MAX - 1);
	 
endmodule