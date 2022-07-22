module seg2(clk, data, rst, dig, segments);

input clk;
input [7:0] data;
input rst;

output reg [3:0] dig;
output reg [7:0] segments;

reg [3:0] data_temp;
reg state;

// dig

always @ (posedge clk or posedge rst)
begin
    if (rst)
    begin
        dig <= 4'b1111;
        data_temp <= 0;
        state <= 0;
    end
    else
    begin
        case (state)
            0: begin
                dig <= 4'b1110;
                data_temp <= data[3:0];
                state <= 1;
            end 
            1: begin
                dig<= 4'b1101;
                data_temp <= data[7:4];
                state <= 0;
            end
            default: state <= 0;
        endcase
    end
end

always @ (*)
begin
    if (rst)
        segments = 8'h00;
    else
    begin
        case (data_temp)
            0: segments = 8'hc0;
            1: segments = 8'hf9;
            2: segments = 8'ha4;
            3: segments = 8'hb0;
            4: segments = 8'h99;
            5: segments = 8'h92;
            6: segments = 8'h82;
            7: segments = 8'hf8;
            8: segments = 8'h80;
            9: segments = 8'h90;
            10: segments = 8'h88;
            11: segments = 8'h83;
            12: segments = 8'hc6;
            13: segments = 8'ha1;
            14: segments = 8'h86;
            15: segments = 8'h8e;
            default: segments = 8'h00;
        endcase
    end
end
endmodule