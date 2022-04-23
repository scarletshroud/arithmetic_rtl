`timescale 1ns / 1ps

module sqrt(
    input clk_i,
    input rst_i,
    input [7:0] x_bi,
    input start_i, 
    output busy_o,
    output reg [7:0] y_bo 
);

    localparam IDLE = 1'b0;
    localparam WORK = 1'b1;
    localparam START = 6'd6;
    localparam END = 6'd0;
    
    reg [7:0] x;
    reg [7:0] b;
    reg [7:0] m;
    reg [7:0] y;
    reg state;
    
    assign end_step = (m == END);
    assign busy_o = state;
        
always @(posedge clk_i)
    if (rst_i) begin
       state <= 0;
       m <= 1 << START;
       y <= 0;
       y_bo <= 0;
    end else begin
    
        case(state)
            IDLE:
                if (start_i) begin
                    state <= WORK;
                    m <= 1 << START;
                    x <= x_bi;
                end
            WORK:
                begin
                    if (end_step) begin
                        state <= IDLE;
                        y_bo <= y;
                    end
                    
                    b = y | m;
                    y = y >> 1;
                    
                    if (x >= b) begin
                         x = x - b;
                         y = y | m;
                    end
                
                    m = m >> 2;
                end
        endcase 
    end
endmodule