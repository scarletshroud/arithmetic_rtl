`timescale 1ns / 1ps

module mul(
    input clk_i,
    input rst_i,
    input [7:0] a_bi,
    input [7:0] b_bi,
    input start_i, 
    output busy_o,
    output reg [15:0] y_bo 
);

    localparam IDLE = 1'b0;
    localparam WORK = 1'b1;
    
    reg [3:0] ctr;
    wire [3:0] end_step;
    wire [3:0] part_sum;
    wire [15:0] shifted_part_sum;
    reg [7:0] a, b;
    reg [15:0] part_res;
    reg state;
    reg state_next;
    
    assign part_sum = a & {8{b[ctr]}};
    assign shifted_part_sum = part_sum << ctr;
    assign end_step = (ctr == 3'd7); //to do fix
    assign busy_o = state;
    
    always @(posedge clk_i)
        if (rst_i) begin
            state <= IDLE;
        end else begin
            state <= state_next;
        end
    
    always @* begin
        case(state)
            IDLE: state_next = (start_i) ? WORK : IDLE; 
            WORK: state_next = (end_step) ? IDLE : WORK;
        endcase
    end
    
    always @(posedge clk_i)
        if (rst_i) begin
            ctr <= 0;
            part_res <= 0;
            y_bo <= 0;
        end else begin
            case (state)
                IDLE:
                    if (start_i) begin
                        a <= a_bi;
                        b <= b_bi;
                        ctr <= 0;
                        part_res <= 0;
                    end
                WORK:
                    begin
                        if (end_step) begin 
                            y_bo <= part_res;
                        end
                        
                        part_res <= part_res + shifted_part_sum;
                        ctr <= ctr + 1;
                    end
            endcase 
        end
endmodule
