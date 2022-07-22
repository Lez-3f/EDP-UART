module uart_rx_test(
    clk, rst_n, sci_rx,
    led, rx_d_val
);

input clk, rst_n, sci_rx;

output [7:0] led;
output rx_d_val;

wire [7:0] data;

uart_rx UR(
    .clk(clk), 
    .rst_n(rst_n), 
    .sci_rx(sci_rx),
    .rx_data(data), 
    .rx_d_val(rx_d_val)
);

led L(
    .data(data),
    .led(led)
);

endmodule