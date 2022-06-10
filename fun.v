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
    
    localparam IDLE = 3'b000;
    localparam CUBE_ON = 3'b001;
    localparam CUBE_WORK = 3'b010;
    localparam SQRT_ON = 3'b011;
    localparam SQRT_WORK = 3'b100;
   
    reg [2:0] state;
    reg [2:0] state_next;
    
    reg [7:0] b;
    wire [7:0] plus_bo; 
    wire [7:0] sqrt_bo;
    wire busy;
   
    reg cube_start;
    wire cube_busy;
    wire [7:0] cube_bo;
      
    cube cub_sqrt_t(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .x_bi(b),
        .start_i(cube_start),
        .busy_o(cube_busy),
        .y_bo(cube_bo)
    );
    
    reg sqrt_start;
    wire sqrt_busy;
    
    sqrt sqrt_t(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .x_bi(plus_bo),
        .start_i(sqrt_start),
        .busy_o(sqrt_busy),
        .y_bo(sqrt_bo)
    );
    
    assign busy_o = (state != IDLE);
    assign plus_bo = a_bi + cube_bo;
    
always @(posedge clk_i)
    if (rst_i) begin
        state <= IDLE;
    end else begin
        state <= state_next;
    end 
    
always @* begin 
    case(state)
        IDLE: state_next <= (start_i) ? CUBE_ON : IDLE;
        SQRT_WORK: state_next <= (sqrt_busy) ? SQRT_WORK : IDLE;
        SQRT_ON: state_next <= SQRT_WORK;
        CUBE_WORK: state_next <= (cube_busy) ? CUBE_WORK : SQRT_ON;
        CUBE_ON: state_next <= CUBE_WORK;
    endcase
end
    
always @(posedge clk_i)
        if (rst_i) begin
            y_bo <= 0;
            cube_start <= 1'b0;
            sqrt_start <= 1'b0;
        end else begin
            case (state)
                IDLE:
                    begin
                        if (start_i) begin
                            b <= b_bi;
                            cube_start <= 1'b1;
                        end
                    end
                SQRT_WORK:
                    begin
                        sqrt_start <= 1'b0;
                        if (!sqrt_busy) begin
                            y_bo <= sqrt_bo;
                        end
                    end   
                CUBE_WORK:
                    begin
                        cube_start <= 1'b0;
                        if (!cube_busy) begin
                            sqrt_start <= 1'b1;
                        end
                    end
            endcase
        end
endmodule
