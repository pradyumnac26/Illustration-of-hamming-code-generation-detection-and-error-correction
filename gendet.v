HAMMING CODE GENERATOR

	module Hamming_generator(
	    input [0:6] data,
	    output [0:11] code_word
	    );
	assign code_word[0] = data[0]^data[1]^data[3]^data[4]^data[6];
	assign code_word[1] = data[0]^data[2]^data[3]^data[5]^data[6];
	assign code_word[2] = data[0];
	assign code_word[3] = data[1]^data[2]^data[3];
	assign code_word[4] = data[1];
	assign code_word[5] = data[2];
	assign code_word[6] = data[3];
	assign code_word[7] = data[4]^data[5]^data[6];
	assign code_word[8] = data[4];
	assign code_word[9] = data[5];
	assign code_word[10]= data[6];	
	assign code_word[11]=^code_word[0:10];
	endmodule

HAMMING CODE DETECTOR

	module hamming_detection(
	    input [0:11] code_word,
	    output reg [0:11] data,
	    output reg [1:0] ds
	    );
	    
	reg [0:11] coded_word;
	wire [3:0] check;
	wire p;
	
	assign p = ^(code_word);
	assign check[0] = code_word[0]^code_word[2]^code_word[4]^code_word[6]^code_word[8]^code_word[10];
	assign check[1] = code_word[1]^code_word[2]^code_word[5]^code_word[6]^code_word[9]^code_word[10];
	assign check[2] = code_word[3]^code_word[4]^code_word[5]^code_word[6];
	assign check[3] = code_word[7]^code_word[8]^code_word[9]^code_word[10];
	
	always@(code_word)
	begin
	    coded_word = code_word;
	    if(p)
	        begin
	            ds = 2'b01;
	            if(check)
	            begin
	                    coded_word[check-1] = ~(coded_word[check-1]) ;
	                    data[8:11] = check;
	             end
	             else
	              data[8:11] = 4'b1100;        
	            
	            extract(coded_word,data[0:6]);   
	            data[7] = 1'b0;
	        end
	    else
	        if(!(check))
	            begin
	            ds = 2'b00;
	            extract(coded_word,data[0:6]);
	            data[7:11] = 4'b0000;
	            end
	        else
	           begin
	           ds = 2'b10;
	           data = coded_word;
	           end 
	end

	task extract;
	input [0:11] c;
	output [0:6] d;
	begin
	        d[0] = c[2];
	        d[1] = c[4];
        	d[2] = c[5];
        	d[3] = c[6];
        	d[4] = c[8];
        	d[5] = c[9];
        	d[6] = c[10];
	end	
	endtask
	endmodule

LFSR

	module Lfsr( clk,rst,y );
	parameter len=8, init=1001001;
	parameter[len:1] tap=8'b1100_1111;
	input clk,rst;
	output [1:len] y;
	reg [1:len] y = init;
	
	always @(posedge clk)
	if (rst) y<= tap;
	else
	        begin
	        y[1]<=y[8];
	        y[2] <= tap[7]?y[1]^y[8]:y[1];
	        y[3] <= tap[6]?y[2]^y[8]:y[2];
	        y[4] <= tap[5]?y[3]^y[8]:y[3];
	        y[5] <= tap[4]?y[4]^y[8]:y[4];
	        y[6] <= tap[3]?y[5]^y[8]:y[5];
	        y[7] <= tap[2]?y[6]^y[8]:y[6];
	        y[8] <= tap[1]?y[7]^y[8]:y[7];
	           end
	endmodule
	
COMBINED MODULE
	
	module Hamming_code(
	    input [0:6] data_input,
	    input single,
	    input double,
	    input clk,rst,
	    output [0:11] data_output,
	    output [1:0] ds
	    );
	wire [0:11] cw;
	wire [1:8] u,v;
	reg [0:11] cwr;
	Hamming_generator u1(data_input,cw);
	hamming_detection u2(cwr,data_output,ds);
	Lfsr u3(clk,rst,u);
	Lfsr #15 u4(clk,rst,v); 
	always@(single,double,data_input)
	begin
	cwr = cw;
	if(double)
	    begin
	        cwr[(u%12)]=~cwr[(u%12)];
	        cwr[(v%12)]=~cwr[(v%12)];    
	    end
	else if(single)
	begin
	cwr[(u%12)]=~cwr[(u%12)];     
	end
	else cwr = cw;
	end
	endmodule
	
