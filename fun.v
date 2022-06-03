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
   
    wire cube_start;
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
    
    wire sqrt_start;
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
    assign sqrt_start = (state == SQRT_ON);
    assign cube_start = (state == CUBE_ON);
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
            b <= b_bi;
            y_bo <= 0;
        end else begin
            case (state)
                IDLE:
                    begin
                        if (start_i) begin
                            
                        end
                    end
                SQRT_WORK:
                    begin
                        y_bo <= sqrt_bo;
                    end   
                CUBE_WORK:
                    begin
                        if (!cube_busy) begin
                            
                        end
                    end
            endcase
        end
endmodule
