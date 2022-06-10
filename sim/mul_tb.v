`timescale 1ns / 1ps

module mul_tb; 
    reg [7:0] a_in;
    reg [7:0] b_in;
    reg clk;
    reg rst;
    reg start;
    wire [15:0] y;
    wire b_o;
     
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
    
    integer i;
    reg[15:0] expected_val;
    
    initial begin     
        clk = 1'b1;
        
        rst = 1'b1;
        
        #10
        
        rst = 1'b0;
                 

        for (i = 0; i < 16; i = i + 1) begin
            
            start = 1'b1; 
            
            #10
            
            a_in = i;
            b_in = i;
            
            #10
            
            start = 1'b0;
            
            expected_val = i * i;
                               
            #500
            
            if ( expected_val == y) begin
                $display("Okay: expected: %d, actual: %d", expected_val, y);
            end else begin
                $display("Error: expected: %d, actual: %d", expected_val, y);
            end
            
        end
        
        rst = 1'b1;
        #100 $stop;
    end
    
endmodule
