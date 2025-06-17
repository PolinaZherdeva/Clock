module AlarmModule (
    input  logic clk,
    input  logic rst,

    // Текущее время
    input  logic [$clog2(60)-1:0] curr_minutes,
    input  logic [$clog2(24)-1:0] curr_hours,

    // Новое время будильника (подаётся только при set_alarm)
    input  logic [$clog2(60)-1:0] new_alarm_minutes,
    input  logic [$clog2(24)-1:0] new_alarm_hours,
    input  logic set_alarm,

    // Выход: сигнал срабатывания будильника
    output logic alarm_trigger,
	 
	 output logic [$clog2(60)-1:0] alarm_minutes_out,
	 output logic [$clog2(24)-1:0] alarm_hours_out
);

    // Внутренние регистры для хранения времени будильника
    logic [$clog2(60)-1:0] alarm_minutes;
    logic [$clog2(24)-1:0] alarm_hours;
	 
	 // Внутренние регистры для передачи времени 
	 logic [$clog2(60)-1:0] alarm_min_out;
    logic [$clog2(24)-1:0] alarm_hour_out;

    // Обновление времени будильника при set_alarm
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            alarm_minutes <= 'x;
            alarm_hours   <= 'x;
        end else if (set_alarm) begin
            alarm_minutes <= new_alarm_minutes;
            alarm_hours   <= new_alarm_hours;
        end
		  
		  // буфер для вывода текущих часов
		  if (alarm_minutes == 'x)
			  alarm_min_out <= 0;
		  if (alarm_hours == 'x)
			  alarm_hour_out <=0;
		  else begin
			  alarm_min_out<= alarm_minutes;
			  alarm_hour_out<= alarm_hours;
		  end
		  
    end

    // Сигнал будильника активируется при совпадении времени
    assign alarm_trigger = (curr_minutes == alarm_minutes) && (curr_hours   == alarm_hours);
	 
	 // Передача текущего сохранённого времени будильника наружу
    assign alarm_minutes_out = alarm_min_out;
    assign alarm_hours_out   = alarm_hour_out;

endmodule