module clk_1k(
    input clk,
    input reset,
    output reg clk_1k
);
reg [15:0] div_reg;
always @ (posedge clk, posedge reset)
if (reset) 
begin
    div_reg <= 0;
    clk_1k <= 0;
end
else 
begin
    if (div_reg < 12500)
        div_reg <= div_reg + 1;
    else
    begin
        div_reg <= 0;
        clk_1k <= ~ clk_1k;
    end
end
endmodule