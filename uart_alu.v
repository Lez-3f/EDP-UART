module uart_alu(
    clk, rst_n, sci_rx,
    sci_tx, led, dig, segments
);

input clk, rst_n, sci_rx;

output sci_tx;
output [7:0] led;
output [3:0] dig;
output [7:0] segments;

reg [3:0] state;
/*

    st == 0: 接收data_a,
    st == 1: 接收data_b,
    st == 2: 接收cs,
    st == 3: 接收carry_in,
    st == 4: 计算结果，显示数据, 发送数据
*/

reg [7:0] alu_data_a;
reg [7:0] alu_data_b;
reg [2:0] alu_cs;
reg alu_cin;

wire [7:0] data_alu_s;

wire alu_zero;
wire alu_cout;

wire [7:0] data_uar;

wire rx_d_val;
wire tx_d_end;

reg en_tx;
reg en_rx;
reg en_alu;

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

always @ (posedge clk or posedge  rst_n)
begin
    if (rst_n)
    begin
        state <= 0;
        alu_data_a <= 0;
        alu_data_b <= 0;
        alu_cs <= 0;
        alu_cin <= 0;

        en_alu <= 0;
        en_rx <= 1; //允许接收
        en_tx <= 0; //不允许发送
    end

    else
    begin
        case (state)
        
        0: begin
            if (rx_d_val)
            begin
                alu_data_a <= data_uar;
                state <= 1;
            end
        end

        1: begin
            if (rx_d_val)
            begin
                alu_data_b <= data_uar;
                state <= 2;
            end
        end

        2: begin
            if (rx_d_val)
            begin
                alu_cs <= data_uar[2:0];
                state <= 3;
            end

        end

        3: begin
            if (rx_d_val)
            begin
                alu_cin <= data_uar[0];         
                en_alu <= 1;

                state <= 0;

                // en_tx <= 1;

                // if (tx_d_end)
                // begin
                //     en_tx <= 0;
                //     state <= 0;
                // end
            end
        end
        // 4: begin

        //     data_alu_s <= data_alu_s;
        //     state <= 0;
        // end
        endcase
    end
end

endmodule