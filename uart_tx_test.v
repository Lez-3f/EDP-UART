module uart_tx_test(
    clk, rst_n, tx_data,
    sci_tx, led
);

parameter en = 1;

input clk, rst_n;
input [7:0] tx_data;

output [7:0] led;
output sci_tx;

uart_tx UT(
    .clk(clk),
    .rst_n(rst_n),
    .tx_data(tx_data),
    .en_tx(en),
    .sci_tx(sci_tx)
);

led L(
    .data(tx_data),
    .led(led)
);

endmodule