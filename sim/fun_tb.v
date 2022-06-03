`timescale 1ns / 1ps

module fun_tb();
    reg clk;
    reg rst;
    reg [7:0] a_in;
    reg [7:0] b_in;
    wire start;
    wire [7:0] y;
    wire b_o;
    
    assign start = ~rst;
    
    fun fun_t (
        .clk_i(clk),
        .rst_i(rst),
        .start_i(start),
        .a_bi(a_in),
        .b_bi(b_in),
        .busy_o(b_0),
        .y_bo(y)
    ); 
    
    integer i;
    integer j;
    reg [7:0] expected_val;
    
    always #10 clk = ~clk; 
    
 
    initial begin
        clk = 1'b1;
        
        for (i = 0; i <= 16; i = i + 1) begin
          for (j = 0; j < 5; j = j + 1) begin
                rst = 1'b1;
                a_in = i;
                b_in = j * j * j;
                expected_val = 5;
                
                #10
                
                rst = 1'b0;
                #1590
                
                $display("actual: %d, a: %d, b: %d", y, a_in, b_in);
                
                /*if (expected_val == y) begin
                    $display("Okay: expected: %d, actual: %d, a: %d, b: %d", expected_val, y, a_in, b_in);
                end else begin
                    $display("Error: expected: %d, actual: %d, a: %d, b: %d", expected_val, y, a_in, b_in);
                end */
           end
        end
        
        rst = 1'b1;
        #100 $stop;
    end 
    
endmodule
