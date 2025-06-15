module SettingsController #(
	parameter MAX_MINUTES = 60,
	parameter MAX_HOURS = 24,
	parameter TIMEOUT_TICKS = 5  // Таймаут в секундах до отката настроек
)
(
	input logic clk, //50 MHz
	input logic rst,
	
	// получаем текущее значение времени
	input logic [$clog2(60):0] minutes_unit, 
	input logic [$clog2(60):0] minutes_ten, 
	
   input logic [$clog2(24):0] hours_unit,
   input logic [$clog2(24):0] hours_ten,
	
	//Режимы (настройка времени/будильника) - переключение switch
	//switch = 1 - настройка, switch = 0 - выход из настрое
   input logic time_mode_switch,   // 1 = установка текущего времени
   input logic alarm_mode_switch,  // 1 = установка будильника
	
	//сохранение введенных значений
	input logic save_switch, // 1 = сохранение значения будильника/текущего времени
	
	//Кнопки изменения часов и минут
	input logic inc_min_btn,
   input logic dec_min_btn,
   input logic inc_hour_btn,
   input logic dec_hour_btn,

   //Переключатели разрядов
   //input logic min_select_switch,   // 0 - единицы минут (по умолчанию), 1 - десятки минут
   //input logic hour_select_switch,  // 0 - единицы часов, 1 - десятки часов

   //Автотики
   //input logic tick_minute, //(флаг-импуль для увелич минут)
   //input logic tick_hour,

   //Выходы текущего времени
   output logic [$clog2(MAX_MINUTES)-1:0] current_minutes,
   output logic [$clog2(MAX_HOURS)-1:0]   current_hours,

   //Выходы будильника
   output logic set_alarm,
   output logic [$clog2(MAX_MINUTES)-1:0] alarm_minutes,
   output logic [$clog2(MAX_HOURS)-1:0]   alarm_hours	
);

	 //Регистры текущего времени и будильника (рабочие) - которые мы изменяем
    logic [$clog2(MAX_MINUTES)-1:0] minutes_reg, alarm_minutes_reg;
    logic [$clog2(MAX_HOURS)-1:0]   hours_reg,   alarm_hours_reg;

    //Сохранённые значения для отката
//    logic [$clog2(MAX_MINUTES)-1:0] original_minutes, original_alarm_minutes;
//    logic [$clog2(MAX_HOURS)-1:0]   original_hours, original_alarm_hours;
	 
	 //Счетчик для отката изменений	
	 //logic [$clog2(TIMEOUT_TICKS+1)-1:0] idle_counter;
	 
	 logic modified;//Флаг внесения изменений (для обнуления счетчика отката)
	 
	 //Подключение регистров к выходам
    assign current_minutes = minutes_reg;
    assign current_hours   = hours_reg;
    assign alarm_minutes   = alarm_minutes_reg;
    assign alarm_hours     = alarm_hours_reg;
	 
	 logic any_press;
	 
	 // --- Основная логика ---
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            // --- Сброс всех состояний ---
            minutes_reg        <= 0;
            hours_reg          <= 0;
            alarm_minutes_reg  <= 0;
            alarm_hours_reg    <= 0;
//            original_minutes   <= 0;
//            original_hours     <= 0;
//            original_alarm_minutes <= 0;
//            original_alarm_hours   <= 0;
//            idle_counter       <= 0;
//            modified           <= 0;
            set_alarm          <= 0;
        end else begin

            //any_press = (!inc_min_btn || !dec_min_btn || !inc_hour_btn || !dec_hour_btn);
		  

            // --- Сохраняем начальные значения при первом изменении ---
            if (!modified && any_press) begin
                original_minutes       <= minutes_reg;
                original_hours         <= hours_reg;
                original_alarm_minutes <= alarm_minutes_reg;
                original_alarm_hours   <= alarm_hours_reg;
            end

            // --- Настройка текущего времени ---
            if (time_mode_switch) begin
                // Минуты
                if (inc_min_btn) begin
                    if (!min_select_switch && minutes_reg < MAX_MINUTES - 1)
                        minutes_reg <= minutes_reg + 1;
                    else if (min_select_switch && minutes_reg <= MAX_MINUTES - 10)
                        minutes_reg <= minutes_reg + 10;
                end else if (dec_min_btn) begin
                    if (!min_select_switch && minutes_reg > 0)
                        minutes_reg <= minutes_reg - 1;
                    else if (min_select_switch && minutes_reg >= 10)
                        minutes_reg <= minutes_reg - 10;
                end

                // Часы
                if (inc_hour_btn) begin
                    if (!hour_select_switch && hours_reg < MAX_HOURS - 1)
                        hours_reg <= hours_reg + 1;
                    else if (hour_select_switch && hours_reg <= MAX_HOURS - 10)
                        hours_reg <= hours_reg + 10;
                end else if (dec_hour_btn) begin
                    if (!hour_select_switch && hours_reg > 0)
                        hours_reg <= hours_reg - 1;
                    else if (hour_select_switch && hours_reg >= 10)
                        hours_reg <= hours_reg - 10;
                end

            end else if (alarm_mode_switch) begin
                // --- Настройка будильника ---
                if (inc_min_btn) begin
                    if (!min_select_switch && alarm_minutes_reg < MAX_MINUTES - 1)
                        alarm_minutes_reg <= alarm_minutes_reg + 1;
                    else if (min_select_switch && alarm_minutes_reg <= MAX_MINUTES - 10)
                        alarm_minutes_reg <= alarm_minutes_reg + 10;
                end else if (dec_min_btn) begin
                    if (!min_select_switch && alarm_minutes_reg > 0)
                        alarm_minutes_reg <= alarm_minutes_reg - 1;
                    else if (min_select_switch && alarm_minutes_reg >= 10)
                        alarm_minutes_reg <= alarm_minutes_reg - 10;
                end

                if (inc_hour_btn) begin
                    if (!hour_select_switch && alarm_hours_reg < MAX_HOURS - 1)
                        alarm_hours_reg <= alarm_hours_reg + 1;
                    else if (hour_select_switch && alarm_hours_reg <= MAX_HOURS - 10)
                        alarm_hours_reg <= alarm_hours_reg + 10;
                end else if (dec_hour_btn) begin
                    if (!hour_select_switch && alarm_hours_reg > 0)
                        alarm_hours_reg <= alarm_hours_reg - 1;
                    else if (hour_select_switch && alarm_hours_reg >= 10)
                        alarm_hours_reg <= alarm_hours_reg - 10;
                end
            end else begin
                // --- Обычный режим: автоинкремент времени ---
                if (tick_minute) begin
                    if (minutes_reg == MAX_MINUTES - 1) begin
                        minutes_reg <= 0;
                        if (hours_reg == MAX_HOURS - 1)
                            hours_reg <= 0;
                        else
                            hours_reg <= hours_reg + 1;
                    end else begin
                        minutes_reg <= minutes_reg + 1;
                    end
                end
            end

            // --- Управление флагами ---
            if (any_press) begin
                idle_counter <= 0;
                modified <= 1;
            end else if (modified) begin
                idle_counter <= idle_counter + 1;
                if (idle_counter >= TIMEOUT_TICKS) begin
                    // --- Время истекло — откат настроек ---
                    minutes_reg        <= original_minutes;
                    hours_reg          <= original_hours;
                    alarm_minutes_reg  <= original_alarm_minutes;
                    alarm_hours_reg    <= original_alarm_hours;
                    modified           <= 0;
                    idle_counter       <= 0;
                end
            end

            // --- Подтверждение установки будильника ---
            if (alarm_mode_switch && modified && !alarm_set_done) begin
                set_alarm <= 1;           // Активируем сигнал
                alarm_set_done <= 1;      // Запоминаем, что установка уже была
                modified <= 0;            // Сброс флага модификации
                idle_counter <= 0;        // Сброс таймера
            end
        end
    end

endmodule
	 