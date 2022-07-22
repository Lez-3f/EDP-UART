module data_ctl(
    clk, rst_n, rx_d_val, rx_data, tx_d_end,
    alu_data_a, alu_data_b, alu_cs, alu_cin, 
    en_alu, en_rx, en_tx
);

input clk, rst_n, rx_d_val, tx_d_end;
input [7:0] rx_data;
output reg [7:0] alu_data_a;
output reg [7:0] alu_data_b;
output reg [2:0] alu_cs;
output reg alu_cin;
output reg en_tx;
output reg en_rx;
output reg en_alu;

reg [3:0] state;

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
                alu_data_a <= rx_data;
                state <= 1;
            end
        end

        1: begin
            if (rx_d_val)
            begin
                alu_data_b <= rx_data;
                state <= 2;
            end
        end

        2: begin
            if (rx_d_val)
            begin
                alu_cs <= rx_data[2:0];
                state <= 3;
            end

        end

        3: begin
            if (rx_d_val)
            begin
                alu_cin <= rx_data[0];         
                en_alu <= 1;

                // state <= 0;
                state <= 4;
            end
        end

        4: begin
            en_rx <= 0;
            en_tx <= 1;

            if (en_tx && tx_d_end)
            begin
                en_rx <= 1;
                en_tx <= 0;

                state <= 0;
            end
        end
        endcase
    end
end

endmodule