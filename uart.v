module uart(
    clk, rst_n, sci_rx,
    sci_tx, led
);

input clk, rst_n, sci_rx;

output sci_tx;
output [7:0] led;

wire [7:0] data;
wire en_tx;
wire en_rx;

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

endmodule