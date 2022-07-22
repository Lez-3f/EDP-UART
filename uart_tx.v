module uart_tx(
    clk, rst_n, tx_data, en_tx,
    sci_tx, tx_d_end
);

/*
    波特率 9600
    时钟频率 25000000

    一个数据位所占的时钟周期： 2604
*/
parameter td = 2604;
parameter td_half = 1302;
parameter start_bit = 1'b0;
parameter end_bit = 1'b1;

input clk;
input rst_n;
input [7:0] tx_data;
input en_tx;

output reg sci_tx;
output reg tx_d_end;

reg [15:0] cnt;
reg [3:0] state;

reg [3:0] tx_idx;

/*
    state = 0, 等待发送数据
    state = 1, 发送起始位
    state = 2, 发送数据
    state = 3, 发送停止位
*/

always @ (posedge clk or posedge rst_n)
begin
    if (rst_n)
    begin
        sci_tx <= 1;

        cnt <= 0;
        state <= 0;
        tx_idx <= 0;
        tx_d_end <= 1;
    end

    else
    begin
        if (state == 0 && en_tx == 1) //允许发送
        begin
            state <= 1;
            sci_tx <= start_bit;    //设为起始位

            tx_d_end <= 0; //未结束
        end

        if (state == 1) //发送起始位
        begin
            cnt <= cnt + 1;

            if (cnt == td)
            begin
                cnt <= 0;
                state <= 2;
                tx_idx <= 0;

                sci_tx <= tx_data[tx_idx];
            end
        end

        if (state == 2)
        begin
            cnt <= cnt + 1;

            if (cnt == td)
            begin
                cnt <= 0;
                sci_tx <= tx_data[tx_idx + 1];
                tx_idx <= tx_idx + 1;

                if (tx_idx == 4'b0111)
                begin
                    state <= 3;
                    sci_tx <= end_bit;
                    tx_idx <= 0;
                end
                // cnt <= 0;
                // tx_idx <= tx_idx + 1;

                // if (tx_idx == 4'b1000)
                // begin
                //     state <= 3;
                //     sci_tx <= end_bit;
                //     tx_idx <= 0;
                // end
                // else sci_tx <= tx_data[tx_idx];
            end
        end

        if (state == 3)
        begin
            cnt <= cnt + 1;

            if (cnt == td)  //发送完数据
            begin
                cnt <= 0;
                state <= 0;

                tx_d_end <= 1;  //结束了
                sci_tx <= 1;
            end
        end
    end
end

endmodule
