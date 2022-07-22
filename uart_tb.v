`timescale 1ns/1ps

module uart_tb;

reg clk, rst_n, sci_rx;
wire [7:0] led;
wire sci_tx;

uart U(
    .clk(clk), 
    .rst_n(rst_n), 
    .sci_rx(sci_rx),
    .sci_tx(sci_tx),
    .led(led)
);

always #1 clk = ~clk;
initial begin
    rst_n = 1;
    clk = 1;
    sci_rx = 1;
    #20000 rst_n = 0;
    #1000 sci_rx = 0; //起始位
    
    // #5208 sci_rx = 1;
    // #5208 sci_rx = 0;
    // #5208 sci_rx = 1;
    // #5208 sci_rx = 0;
    // #5208 sci_rx = 1;
    // #5208 sci_rx = 0;
    // #5208 sci_rx = 1;
    // #5208 sci_rx = 0;
    #5208 sci_rx = 0;
    #5208 sci_rx = 1;
    #5208 sci_rx = 0;
    #5208 sci_rx = 0;
    #5208 sci_rx = 0;
    #5208 sci_rx = 0;
    #5208 sci_rx = 1;
    #5208 sci_rx = 0;

    #5208 sci_rx = 1;   //终止位
    #50000;

end
endmodule