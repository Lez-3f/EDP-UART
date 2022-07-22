module led(
    data, 
    led
);

input [7:0] data;
output reg[7:0] led;

always @ (*)
begin
    led <= data;
end

endmodule