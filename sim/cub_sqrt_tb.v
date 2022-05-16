`timescale 1ns / 1ps

module cube_tb( );

    reg clk, rst;
    reg [7:0] x;
    wire busy, start;
    wire [7:0] y;
    
    assign start = ~rst;
    
    cube cub_rt( 
        .clk_i( clk ),
        .rst_i( rst ),
        .x_bi( x ),
        .start_i(start),
        .busy_o( busy ),
        .y_bo( y ) 
    );
       
    integer i;
    reg [7:0] expected_val;
    
    always #10 clk = ~clk;
    
    initial begin
        clk = 1'b1;
        i = 7;
        
        rst = 1'b1;
        x = i * i * i;
        
        #10
        
        expected_val = i;
        
        rst = 1'b0;
        
        #1000
        if ( expected_val == y ) begin
            $display( "CORRECT: actual: %d, expected: %d", y, expected_val );
        end else begin
            $display( "ERROR: actual: %d, expected: %d, x: %d", y, expected_val, x );
        end
        
        rst = 1'b1;
        #20 $stop;
    end
endmodule
