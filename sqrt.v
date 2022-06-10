`timescale 1ns / 1ps

module sqrt(
    input clk_i,
    input rst_i,
    input [7:0] x_bi,
    input start_i, 
    output busy_o,
    output reg [7:0] y_bo 
);

    localparam IDLE = 2'b00;
    localparam WORK = 2'b01;
    localparam WORK2 = 2'b10;
    localparam WORK3 = 2'b11;
    localparam START = 6'd6;
    localparam END = 6'd0;
    
    reg [7:0] x;
    reg [7:0] m;
    reg [7:0] y;
    reg [7:0] b;
    wire end_step;
    
    reg [1:0] state;
    reg [1:0] state_next;
    
    assign end_step = (m == END);
    assign busy_o = (state != IDLE);
    
     always @(posedge clk_i)
        if (rst_i) begin
            state <= IDLE;
        end else begin
            state <= state_next;
        end
    
    always @* begin
        case(state)
            IDLE: state_next = (start_i) ? WORK : IDLE; 
            WORK: state_next = (end_step) ? IDLE : WORK2;
            WORK2: state_next = WORK3;
            WORK3: state_next = WORK;
        endcase
    end
        
    always @(posedge clk_i)
        if (rst_i) begin
           m <= 1 << START;
           y <= 0;
           y_bo <= 0;
        end else begin
            case(state)
                IDLE:
                    if (start_i) begin
                        m <= 1 << START;
                        x <= x_bi;
                        y <= 0;
                    end
                WORK:
                    begin
                        if (end_step) begin
                            y_bo <= y;
                        end
                        
                        b <= y | m;
                    end  
                        
                WORK2:
                    begin
                        y <= y >> 1;
                    end
                    
                WORK3:
                    begin
                        if (x >= b) begin
                             x <= x - b;
                             y <= y | m;
                        end
                        
                        m <= m >> 2;
                    end
            endcase 
    end
endmodule