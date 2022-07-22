`timescale 1ns/1ps
module uart_alu_top_tb;

reg clk, rst_n, sci_rx;
wire sci_tx;
wire [7:0]led;
wire [3:0] dig;
wire [7:0] segments;

uart_alu_top UAT(
    .clk(clk), .rst_n(rst_n), .sci_rx(sci_rx),
    .sci_tx(sci_tx), .led(led), .dig(dig), .segments(segments)
);

always #1 clk = ~clk;

initial begin
    rst_n = 1;
    clk = 1;
    sci_rx = 1;
    #20000 rst_n = 0;
    // 35
    #5208 sci_rx = 0;   //起始位

    #5208 sci_rx = 1;
    #5208 sci_rx = 0;
    #5208 sci_rx = 1;
    #5208 sci_rx = 0;
    #5208 sci_rx = 1;
    #5208 sci_rx = 1;
    #5208 sci_rx = 0;
    #5208 sci_rx = 0;    

    #5208 sci_rx = 1;   //终止位
    
    // 24
    #5208 sci_rx = 0;   //起始位

    #5208 sci_rx = 0;
    #5208 sci_rx = 0;
    #5208 sci_rx = 1;
    #5208 sci_rx = 0;
    #5208 sci_rx = 0;
    #5208 sci_rx = 1;
    #5208 sci_rx = 0;
    #5208 sci_rx = 0;    

    #5208 sci_rx = 1;   //终止位
    
    // 06
    #5208 sci_rx = 0;   //起始位

    #5208 sci_rx = 0;
    #5208 sci_rx = 1;
    #5208 sci_rx = 1;
    #5208 sci_rx = 0;
    #5208 sci_rx = 0;
    #5208 sci_rx = 0;
    #5208 sci_rx = 0;
    #5208 sci_rx = 0;    

    #5208 sci_rx = 1;   //终止位
    
    // 01
    #5208 sci_rx = 0;   //起始位

    #5208 sci_rx = 1;
    #5208 sci_rx = 0;
    #5208 sci_rx = 0;
    #5208 sci_rx = 0;
    #5208 sci_rx = 0;
    #5208 sci_rx = 0;
    #5208 sci_rx = 0;
    #5208 sci_rx = 0;    

    #5208 sci_rx = 1;   //终止位
    

    #50000;
end


endmodule