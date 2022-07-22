module uart_alu_top(
    clk, rst_n, sci_rx,
    sci_tx, led, dig, segments
);

input clk, rst_n, sci_rx;

output sci_tx;
output [7:0] led;
output [3:0] dig;
output [7:0] segments;

wire [7:0] alu_data_a;
wire [7:0] alu_data_b;
wire [2:0] alu_cs;
wire alu_cin;

wire [7:0] data_alu_s;

wire alu_zero;
wire alu_cout;

wire [7:0] data_uar;

wire rx_d_val;
wire tx_d_end;

wire en_tx;
wire en_rx;
wire en_alu;

uart_rx UR(
    .clk(clk), 
    .rst_n(rst_n), 
    .sci_rx(sci_rx),
    .en_rx(en_rx),

    .rx_data(data_uar), 
    .rx_d_val(rx_d_val)
);

uart_tx UT(
    .clk(clk), 
    .rst_n(rst_n), 
    .tx_data(data_alu_s),
    .en_tx(en_tx),

    .sci_tx(sci_tx),
    .tx_d_end(tx_d_end)
);

led LD(
    .data(data_uar),
    .led(led)
);

clk_1k CL1(
    .clk(clk),
    .reset(rst_n),
    .clk_1k(clk_1k)
);

seg2 SG(
    .clk(clk_1k),
    .data(data_alu_s),
    .rst(rst_n),
    .dig(dig),
    .segments(segments)
);

data_ctl DC(
    .clk(clk), 
    .rst_n(rst_n), 
    .rx_d_val(rx_d_val), 
    .rx_data(data_uar),
    .tx_d_end(tx_d_end),

    .alu_data_a(alu_data_a), 
    .alu_data_b(alu_data_b), 
    .alu_cs(alu_cs), 
    .alu_cin(alu_cin), 

    .en_alu(en_alu), 
    .en_rx(en_rx), 
    .en_tx(en_tx)
);

alu_en ALU(
    .clk(clk),
    .data_a(alu_data_a),
    .data_b(alu_data_b),
    .cs(alu_cs),
    .carry_in(alu_cin),
    .en_alu(en_alu),
    .rst_n(rst_n),
    
    .s(data_alu_s),
    .zero(alu_zero),
    .carry_out(alu_cout)
);


endmodule