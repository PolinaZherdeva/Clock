module SettingsController #(
	parameter MAX_MINUTES = 60,
	parameter MAX_HOURS = 24
)
(
	input logic clk, //50 MHz
	input logic rst,
	
	
	// получаем текущее значение времени
	input logic [$clog2(60):0] cur_minutes, 
   input logic [$clog2(24):0] cur_hours,

	
	// получаем текущее значение установленного будильника
//	input logic [$clog2(60)-1:0] cur_alarm_minutes,
//	input logic [$clog2(24)-1:0] cur_alarm_hours,
	
	
	//Режимы (настройка времени/будильника) - переключение switch
	//switch = 1 - настройка, switch = 0 - выход из настрое
   input logic time_mode_switch,   // 1 = установка текущего времени
   input logic alarm_mode_switch,  // 1 = установка будильника
	
	//Выбор десятков/единиц для изменения в настройках
	input logic min_tens_switch, //0 - единицы, 1 - десятки
	input logic hours_tens_switch,
	
	//сохранение введенных значений
	input logic save_switch, // 1 = сохранение значения будильника/текущего времени
	
	//Кнопки изменения часов и минут
	input logic inc_min_btn,
   input logic dec_min_btn,
   input logic inc_hour_btn,
   input logic dec_hour_btn,

   //Выходы текущего времени
   output logic [$clog2(MAX_MINUTES)-1:0] minutes_settings,
   output logic [$clog2(MAX_HOURS)-1:0]hours_settings,
	output logic set_time //флаг сохранения нового времени

   //Выходы будильника
//   output logic set_alarm,
//   output logic [$clog2(MAX_MINUTES)-1:0] alarm_minutes,
//   output logic [$clog2(MAX_HOURS)-1:0]   alarm_hours	
);

	 //Регистры текущего времени и будильника (рабочие) - которые мы изменяем ????? - туда нужно передать значение 1 ра
    logic [$clog2(MAX_MINUTES):0] minutes_reg, alarm_minutes_reg;
    logic [$clog2(MAX_HOURS):0]   hours_reg,   alarm_hours_reg;
	 
	 logic modified = 0;//Флаг внесения изменений (для единоразовой загрузки значения)
	 logic set_new_time = 0; //флаг - буфер для подачи сигнала установки нового времени
	 
	 // Предыдущее состояние кнопок
	 logic inc_min_btn_prev, dec_min_btn_prev;
	 logic inc_hour_btn_prev, dec_hour_btn_prev;
	 
	 // Временные сигналы (pressed)
	 logic inc_min_pressed, dec_min_pressed;
	 logic inc_hour_pressed, dec_hour_pressed;
	 
	 // --- Основная логика ---
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            // --- Сброс всех состояний ---
            minutes_reg        <= 0;
            hours_reg          <= 0;
				modified           <= 0;
				
				// Сброс истории кнопок
			   inc_min_btn_prev  <= 1;
			   dec_min_btn_prev  <= 1;
			   inc_hour_btn_prev <= 1;
			   dec_hour_btn_prev <= 1;
            //alarm_minutes_reg  <= 0;
            //alarm_hours_reg    <= 0;
//            original_minutes   <= 0;
//            original_hours     <= 0;
//            original_alarm_minutes <= 0;
//            original_alarm_hours   <= 0;
//            idle_counter       <= 0;
//            modified           <= 0;
            //set_alarm          <= 0;
        end else begin
				// --- Обнаружение нажатий (переход 1 -> 0) ---
				inc_min_pressed  <= (inc_min_btn_prev  == 1 && inc_min_btn  == 0);
				dec_min_pressed  <= (dec_min_btn_prev  == 1 && dec_min_btn  == 0);
				inc_hour_pressed <= (inc_hour_btn_prev == 1 && inc_hour_btn == 0);
				dec_hour_pressed <= (dec_hour_btn_prev == 1 && dec_hour_btn == 0);

            // --- Сохраняем начальные значения при первом изменении --- нужен флаг для сохранения 1 раз????
            if (time_mode_switch && !modified) begin
					hours_reg <= cur_hours;
               minutes_reg <= cur_minutes;
					modified <= 1;
            end else if (save_switch && time_mode_switch && modified) begin
					 // Обработка нажатия кнопок
					 // минуты
					 if (inc_min_pressed && !min_tens_switch)
                    minutes_reg <= (minutes_reg + 1) % 60;
                else if (inc_min_pressed && min_tens_switch)
                    minutes_reg <= (minutes_reg + 10) % 60;
                else if (dec_min_pressed && !min_tens_switch)
                    minutes_reg <= (minutes_reg + 59) % 60;
                else if (dec_min_pressed && min_tens_switch)
                    minutes_reg <= (minutes_reg + 50) % 60;
						  
					 //часы
                else if (inc_hour_pressed && !hours_tens_switch)
                    hours_reg <= (hours_reg + 1) % 24;
                else if (inc_hour_pressed && hours_tens_switch)
                    hours_reg <= (hours_reg + 10) % 24;
                else if (dec_hour_pressed && !hours_tens_switch)
                    hours_reg <= (hours_reg + 23) % 24;
                else if (dec_hour_pressed && hours_tens_switch)
                    hours_reg <= (hours_reg + 14) % 24;
				end else if (!save_switch && time_mode_switch && modified) begin
					set_new_time <= 1;
				end
				// Выход из режима настройки
            else if (!time_mode_switch && modified) begin
                modified <= 0;
                set_new_time <= 0;
            end else begin
                set_new_time <= 0; // сбросим однобитный импульс
            end
				
				// Обновление истории кнопок
				inc_min_btn_prev  <= inc_min_btn;
				dec_min_btn_prev  <= dec_min_btn;
				inc_hour_btn_prev <= inc_hour_btn;
				dec_hour_btn_prev <= dec_hour_btn;
            
        end
    end
	 
	 // Вывод значений часов и минут
	 assign minutes_settings = minutes_reg;
	 assign hours_settings   = hours_reg;
	 assign set_time = set_new_time;

endmodule
	 