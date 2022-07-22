module uart_rx(
    clk, rst_n, sci_rx, en_rx,
    rx_data, rx_d_val
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
input sci_rx;
input en_rx;

output reg [7:0] rx_data;
output reg rx_d_val;    //数据是否有效

reg [3:0] rx_idx;
reg [3:0] state;
/*
    state = 0, 等待起始位
    state = 1, 起始位检验
    state = 2, 数据采样
    state = 3, 停止位检验，确定数据是否有效
*/

reg [15:0] cnt; //计时器

reg end_ck;

always @ (posedge clk or posedge rst_n)
begin
    if (rst_n)
    begin
        rx_data <= 8'b00000000;
        rx_d_val <= 0;
        rx_idx <= 0;

        state <= 0;
        cnt <= 0;
        end_ck <= 0;
    end

    else //clk
    begin
        
        if (en_rx == 1 && state == 0) //起始位
        begin           
            rx_d_val <= 0;
            end_ck <= 0;

            if (sci_rx == start_bit)
            begin
                state <= 1;
                cnt <= 0;
            end
        end

        if (state == 1)     //进入起始位检查
        begin
            cnt <= cnt + 1;

            if (sci_rx != 0)
            begin
                state <= 0; //起始位错误
            end

            if (cnt == td_half)
            begin
                cnt <= 0;
                state <= 2;
                rx_idx <= 0;
                rx_d_val <= 0;  //新的数据
            end
        end

        if (state == 2) //进入数据采样
        begin
            cnt <= cnt + 1;

            if (cnt == td)
            begin
                cnt <= 0;
                rx_data[rx_idx] <= sci_rx;
                rx_idx <= rx_idx + 1;
            end

            if (rx_idx == 4'b1000)
            begin
                state <= 3;
            end
        end

        if (state == 3) //结束位检查
        begin
            cnt <= cnt + 1;

            if (cnt == td)
            begin
                end_ck <= (sci_rx == end_bit); //数据接收完毕
            end

            if (cnt == td + td_half)
            begin
                cnt <= 0;
                state <= 0; //结束了
                rx_d_val <= end_ck;
            end
        end
    end
end

endmodule