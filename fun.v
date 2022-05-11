`timescale 1ns / 1ps

module fun(
    input clk_i,
    input rst_i,
    input start_i,
    input [7:0] a_bi,
    input [7:0] b_bi,
    output busy_o,
    output reg [7:0] y_bo
);
    
    localparam IDLE = 2'bs0;
    localparam CUB_SQRT = 2'b01;
    localparam SQRT = 2'b10;
   
    reg [1:0] state = IDLE;
    reg [7:0] b;
    wire [7:0] plus_bo; 
    wire [7:0] cub_sqrt_bo;
    wire [7:0] sqrt_bo;
    wire [1:0] busy;
      
     cub_sqrt cub_sqrt_t(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .x_bi(b),
        .start_i(),
        .busy_o(),
        .y_bo(cub_sqrt_bo)
    );
    
    sqrt sqrt_t(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .x_bi(plus_bo),
        .start_i(),
        .busy_o(),
        .y_bo(sqrt_bo)
    );
    
    assign busy_o;
    assign plus_bo = a_bi + cub_sqrt_bo;
    
always @(posedge clk_i)
        if (rst_i) begin
            state <= IDLE;
            b <= 0;
            y_bo <= 0;
        end else begin
            
            case (state)
                IDLE:
                    if (start_i) begin
                        state <= CUB_SQRT;
                    end
                         
                SQRT:
                    begin
                        state <= IDLE;
                        y_bo = sqrt_bo;
                    end
                    
                CUB_SQRT:
                    begin
                        state <= SQRT;
                        b <= b_bi;
                    end
            endcase
        end
endmodule
