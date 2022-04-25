`timescale 1ns / 1ps

module sqrt_tb;
    reg clk;
    reg rst;
    reg [7:0] x_in;
    wire start;
    wire [7:0] y;
    wire b_o;
    
    assign start = ~rst;
    
    sqrt sqrt_t (
        .clk_i(clk),
        .rst_i(rst),   
        .x_bi(x_in),
        .start_i(start), 
        .busy_o(b_o),
        .y_bo(y)
    );
    
    integer i;
    reg [7:0] test_val;
    
    always #10 clk = ~clk;
        
    initial begin
        clk = 1'b1;
        rst = 1'b1;
        x_in = 0;
        
        #10
        
        x_in = 8'd9;
        rst = 1'b0;
        
        #130
        
        $display("Result %d", y); 
    end
    
endmodule
