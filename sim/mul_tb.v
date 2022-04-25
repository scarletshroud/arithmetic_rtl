`timescale 1ns / 1ps

module mul_tb; 
    reg [7:0] a_in;
    reg [7:0] b_in;
    reg clk;
    reg rst;
    wire start;
    wire [7:0] y;
    wire b_o;
   
    assign start = ~rst;
   
    mul m(
        .clk_i(clk),
        .rst_i(rst),
        .a_bi(a_in),
        .b_bi(b_in),
        .start_i(start),
        .busy_o(b_o),
        .y_bo(y)
    );
    
    always #10 clk = ~clk; 
    
    initial begin
        clk = 1'b1;
        rst = 1'b1; 
        a_in = 3;
        b_in = 5;
        
        $display("Result %d", y); 
    end
    
endmodule
