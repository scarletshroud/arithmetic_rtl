`timescale 1ns / 1ps

module cub_sqrt(
    input clk_i,
    input rst_i,
    input [7:0] x_bi,
    input start_i, 
    output busy_o,
    output reg [7:0] y_bo 
);

    localparam IDLE = 1'b0;
    localparam WORK = 1'b1;
    localparam START = 6'sd6;
    localparam END = -(6'sd3);
    
    reg [7:0] x;
    reg [7:0] b;
    reg [5:0] s;
    reg [7:0] y;
    wire [5:0] end_step;
    reg state = IDLE;
    
    assign end_step = (s == END);
    assign busy_o = state;
        
always @(posedge clk_i)
    if (rst_i) begin
       state <= IDLE;
       s <= START;
       y <= 0;
       y_bo <= 0;
    end else begin
        case(state)
            IDLE:
                if (start_i) begin
                    state <= WORK;
                    s <= START;
                    x <= x_bi;
                    y_bo <= 0;
                    b <= 1 << s;
                end
            WORK:
                begin
                    if (end_step) begin
                        state <= IDLE;
                        y_bo <= y;
                    end
                    
                    y = y << 1;
                    b = (3*y*(y+1)+1) << s;
                    
                    if (x >= b) begin
                        x = x - b;
                        y = y + 1;
                    end
                    
                    s = s - 3;
                end
        endcase 
    end
endmodule