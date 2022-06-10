`timescale 1ns / 1ps

module cube (
    input clk_i,
    input rst_i,
    input [7:0] x_bi,
    input start_i, 
    output busy_o,
    output reg [7:0] y_bo 
);

    localparam IDLE = 3'b000;
    localparam STATE1 = 3'b001;
    localparam STATE2 = 3'b010;
    localparam STATE3 = 3'b011;
    localparam STATE4 = 3'b100;
    
    localparam START = 6'sd6;
    localparam END = -(6'sd3);
    
    reg [7:0] x;
    reg [7:0] b;
    reg [5:0] s;
    reg [7:0] y;
    wire [5:0] end_step;
    
    reg [2:0] state = IDLE;
    reg [2:0] state_next;
    
    assign end_step = (s == END);
    assign busy_o = (state != IDLE);
    
    reg [7:0] mul_a; 
    reg [7:0] mul_b;
    wire [15:0] mul_out;
    reg mul_start;
    wire mul_busy;
    
    mul mul_t (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .a_bi(mul_a), 
        .b_bi(mul_b),
        .start_i(mul_start),
        .busy_o(mul_busy),
        .y_bo(mul_out)
    );
        
always @(posedge clk_i)
    if (rst_i) begin
        state <= IDLE;
    end else begin
        state <= state_next;
    end
    
always @* begin
    case(state) 
        IDLE: state_next = (start_i) ? STATE1 : IDLE;
        STATE1: state_next = (end_step) ? IDLE : STATE2;
        STATE2: state_next = mul_busy ? STATE2 : STATE3;
        STATE3: state_next = mul_busy ? STATE3 : STATE4;
        STATE4: state_next = STATE1;
    endcase
end  
        
always @(posedge clk_i)
    if (rst_i) begin
       s <= START;
       y <= 0;
       y_bo <= 0;
       x <= x_bi;
       mul_start <= 1'b0;
    end else begin
        case(state)
            IDLE: 
                begin
                    if (start_i) begin
                        x <= x_bi;
                        mul_a <= 3;
                        mul_b <= y;
                        s <= START;
                        y <= 0;
                    end
                end
                
            STATE1:
                begin
                    if (!end_step) begin
                        mul_start <= 1'b1;
                        b <= 1 << s;
                        y <= y << 1;
                    end else begin
                        y_bo <= y;
                    end
                end
                
            STATE2:
                begin
                    
                    if (!mul_busy) begin
                        mul_a <= mul_out;
                        mul_b <= y + 1;
                        mul_start <= 1'b1;
                    end else begin
                        mul_start <= 1'b0;
                    end
                end
            
            STATE3:
                begin
                    mul_start <= 1'b0;
                    if (!mul_busy) begin
                        
                        b <= (mul_out + 1) << s;
                    
                        if (x >= b) begin
                            x <= x - b;
                            y <= y + 1;
                        end
                            
                        s <= s - 3;
                    end
                end
                
            STATE4:
                begin
                    mul_a <= 3;
                    mul_b <= y;
                end
        endcase 
    end
endmodule