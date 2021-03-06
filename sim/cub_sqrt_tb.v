`timescale 1ns / 1ps

module cube_tb();

    reg clk;
    reg rst;
    reg [7:0] x;
    wire busy;
    reg start;
    wire [7:0] y;
    
    cube cube_rt( 
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
        rst = 1'b1;
        
        #10
       
        rst = 1'b0;
        
        for ( i = 0; i < 5; i = i + 1 ) begin
        
            start = 1'b1; 
            
            #10
            
            x = i * i * i;
            
            #20
            
            start = 1'b0;
            
            expected_val = i;
                      
            #770
            
            if ( expected_val == y ) begin
                $display( "CORRECT: actual: %d, expected: %d", y, expected_val );
            end else begin
                $display( "ERROR: actual: %d, expected: %d, x: %d", y, expected_val, x );
            end
        end
        
        rst = 1'b1;
        
        #80 $stop;
    end
endmodule
