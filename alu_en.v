module alu_en (
    clk, data_a, data_b, cs, carry_in, en_alu, rst_n,
    s, zero, carry_out
);

input clk;
input [7:0] data_a;
input [7:0] data_b;
input [2:0] cs;
input carry_in;
input en_alu;   //使能ALU
input rst_n;

output reg [7:0] s;
output reg zero;
output reg carry_out;

parameter   AND = 3'b000,
            OR = 3'b001,
            ADD = 3'b010,
            SUB = 3'b011,
            SLT = 3'b100,
            SUBC= 3'b101,
            ADDC= 3'b110; 

always @(posedge clk or posedge rst_n) 
begin
    if (rst_n)
    begin
        s <= 0;
        zero <= 1;
        carry_out <= 0;
    end

    else // clk
    begin
        
        if (en_alu)
        begin
            carry_out <= 0;

            case (cs)
            AND: begin
                s <= data_a & data_b;
            end
            OR: begin
                s <= data_a | data_b;
            end
            ADD: begin
                s <= data_a + data_b;
            end
            SUB: begin
                s <= data_a - data_b;
            end
            SLT: begin
                s <= (data_a < data_b);
            end
            SUBC: begin
                if (data_a - carry_in < data_b) //需要借位
                begin
                    carry_out <= 1;
                end
                s <= {carry_out, data_a} - data_b - carry_in;
            end
            ADDC: begin
                {carry_out, s} <= data_a + data_b + carry_in;
            end
            endcase  
        end

        // 设置 zero 位
        zero <= (s == 8'b00000000);

    end
end
    
endmodule