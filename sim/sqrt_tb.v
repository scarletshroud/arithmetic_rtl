`timescale 1ns / 1ps

module sqrt_tb;
    reg clk;
    reg rst;
    reg [7:0] x_in;
    reg start;
    wire [7:0] y;
    wire b_o;
    
    sqrt sqrt_t (
        .clk_i(clk),
        .rst_i(rst),   
        .x_bi(x_in),
        .start_i(start), 
        .busy_o(b_o),
        .y_bo(y)
    );
    
    integer i;
    reg [7:0] expected_val;
    
    always #10 clk = ~clk;
        
    initial begin
        clk = 1'b1;
        rst = 1'b1;
        
        #10
        
        rst = 1'b0;
        
        for (i = 0; i <= 15; i = i + 1) begin
        
            start = 1'b1; 
            
            #10
            
            x_in = i * i;            

            #10
                      
            start = 1'b0;
            expected_val = i;
            
        
            #280
        
            if (expected_val == y) begin
                $display("Okay: expected: %d, actual: %d", expected_val, y);
            end else begin
                $display("Error: expected: %d, actual: %d", expected_val, y);
            end
        end
        
        rst = 1'b1;
        #100 $stop;
    end
    
endmodule