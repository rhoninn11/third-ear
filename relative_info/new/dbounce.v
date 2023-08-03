module debounce #(parameter DEBNC_CLOCKS = 16, PORT_WIDTH = 4)
(
    input clk,
    input [PORT_WIDTH-1:0] signal_in,
    output [PORT_WIDTH-1:0] signal_out
);
    localparam CNTR_WIDTH = $clog2(DEBNC_CLOCKS);
    localparam CNTR_MAX = DEBNC_CLOCKS - 1;
    reg [CNTR_WIDTH-1:0] sig_cntrs_ary [0:PORT_WIDTH-1];
    reg [PORT_WIDTH-1:0] sig_out_reg;

    integer index;
    
    always @(posedge clk)
    begin
        for (index = 0; index < PORT_WIDTH; index = index + 1)
        begin
            if (sig_cntrs_ary[index] == CNTR_MAX)
                sig_out_reg[index] <= ~sig_out_reg[index];
        end
    end

    always @(posedge clk)
    begin
        for (index = 0; index < PORT_WIDTH; index = index + 1)
        begin
            if ((sig_out_reg[index] == 1'b1) ^ (signal_in[index] == 1'b1))
            begin
                if (sig_cntrs_ary[index] == CNTR_MAX)
                    sig_cntrs_ary[index] <= 0;
                else
                    sig_cntrs_ary[index] <= sig_cntrs_ary[index] + 1'b1;
            end
            else
                sig_cntrs_ary[index] <= 0;
        end
    end
   
    assign signal_out = sig_out_reg;
endmodule