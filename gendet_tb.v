HAMMING CODE GENERATOR

	module Hamming_generator_tb();
	reg [0:6] data;
	wire [0:11] code_word;
	Hamming_generator uut(data,code_word);	
	initial
	begin
	data = 7'b1011001;
	#5 $finish;
	end
	endmodule
	
HAMMING CODE DETECTOR

	module hamming_detection_tb();
	reg [0:11] code_word;
	wire [0:11] data;
	wire [1:0] ds;
	hamming_detection uut(code_word,data,ds);
	initial
	begin
	code_word = 12'b101001110010;
	#5 code_word = 12'b101001110011;
	#5 code_word = 12'b001001111010;
	#5 $finish;
	end
	endmodule

COMBINED MODULE

	module Hamming_code_tb();
	reg [0:6] data_input;
	reg single,double,clk,rst;
	wire [0:11] data_output;
	wire [1:0] ds;
	Hamming_code uut(data_input,single,double,clk,rst,data_output,ds);
	initial clk = 0;
	always #1 clk=~clk;
	initial
	begin
	rst = 1;	
	single = 1;
	double = 0;
	data_input = 7'b1011001;
	#0.1 single =0;
	#10 rst=0;
	#20 {single,double} = 2'b10;
	#20 {single,double} = 2'b01;
	#20 {single,double} = 2'b10;
	#20 {single,double} = 2'b00;
	#20 {single,double} = 2'b01;
	#20 $finish ;
	end
	endmodule
