module DigitSplitter (
    input  logic [5:0] digit,
    output logic [3:0] units,  	 
    output logic [2:0] tens    
     
);

    assign units = digit % 10;
    assign tens = digit / 10;
 
endmodule