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
    
    localparam IDLE = 2'b00;
    localparam CUB_SQRT = 2'b01;
    localparam SQRT = 2'b10;
   
    reg [1:0] state;
    reg [1:0] state_next;
    
    reg [7:0] b;
    wire [7:0] plus_bo; 
    wire [7:0] sqrt_bo;
    wire [1:0] busy;
    
    reg cube_rst;
    wire cube_start;
    wire cube_busy;
    wire [7:0] cube_bo;
      
     cube cub_sqrt_t(
        .clk_i(clk_i),
        .rst_i(cube_rst),
        .x_bi(b),
        .start_i(cube_start),
        .busy_o(cube_busy),
        .y_bo(cube_bo)
    );
    
    reg sqrt_rst;
    wire sqrt_start;
    wire sqrt_busy;
    
    sqrt sqrt_t(
        .clk_i(clk_i),
        .rst_i(sqrt_rst),
        .x_bi(plus_bo),
        .start_i(sqrt_start),
        .busy_o(sqrt_busy),
        .y_bo(sqrt_bo)
    );
    
    assign busy_o = ~start_i;
    assign plus_bo = a_bi + cube_bo;
    
always @(posedge clk_i)
    if (rst_i) begin
        state <= CUB_SQRT;
    end else begin
        state <= state_next;
    end 
    
always @* begin 
    case(state)
        IDLE: state_next = CUB_SQRT;
        SQRT: state_next = (sqrt_busy) ? SQRT : IDLE;
        CUB_SQRT: state_next = (cube_busy) ? CUB_SQRT : SQRT;
    endcase
end
    
always @(posedge clk_i)
        if (rst_i) begin
            state <= IDLE;
            cube_rst <= 0;
            b <= 0;
            y_bo <= 0;
        end else begin
            case (state)
                IDLE:
                    if (start_i) begin
                        b <= 0;
                        y_bo <= 0;
                    end
                         
                SQRT:
                    begin
                        if (sqrt_busy) begin
                            sqrt_rst <= 0;
                        end else begin
                            y_bo = sqrt_bo;
                        end
                    end
                    
                CUB_SQRT:
                    begin
                        if (cube_busy) begin
                            cube_rst <= 0;
                        end else begin
                            b <= b_bi;
                        end
                    end
            endcase
        end
endmodule
