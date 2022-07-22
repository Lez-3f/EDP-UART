module alu (
    data_a, data_b, cs, carry_in,
    s, zero, carry_out
);

input [7:0] data_a;
input [7:0] data_b;
input [2:0] cs;
input carry_in;

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

always @(*) 
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

    // 设置 zero 位
    zero <= (s == 8'b00000000);
end
    
endmodule