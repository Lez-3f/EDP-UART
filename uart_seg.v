module uart_seg(
    clk, rst_n, sci_rx,
    sci_tx, led, dig, segments
);

input clk, rst_n, sci_rx;

output sci_tx;
output [7:0] led;
output [3:0] dig;
output [7:0] segments;

wire [7:0] data;
wire en_tx;
wire en_rx;

wire clk_1k;

uart_rx UR(
    .clk(clk), 
    .rst_n(rst_n), 
    .sci_rx(sci_rx),
    .en_rx(en_rx),

    .rx_data(data), 
    .rx_d_val(en_tx)
);

uart_tx UT(
    .clk(clk), 
    .rst_n(rst_n), 
    .tx_data(data),
    .en_tx(en_tx),

    .sci_tx(sci_tx),
    .tx_d_end(en_rx)
);

led LD(
    .data(data),
    .led(led)
);

clk_1k CL1(
    .clk(clk),
    .reset(rst_n),
    .clk_1k(clk_1k)
);

seg2 SG(
    .clk(clk_1k),
    .data(data),
    .rst(rst_n),
    .dig(dig),
    .segments(segments)
);

endmodule