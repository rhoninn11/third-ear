module pre_spi(
    input wire clk,

    // === spi ===
    // in
    input wire cs_n,
    input wire mosi,
    input wire sclk,
    
    // out
    output wire miso,

    // === custom === 
    output reg [15:0] cycles_num,
    output reg cycles_num_rdy);

    reg cs_n_sync;
    reg mosi_sync;
    reg sclk_sync;
    always @(posedge clk) begin
        cs_n_sync <= cs_n;
        mosi_sync <= mosi;
        sclk_sync <= sclk;
    end

    reg sclk_sync_r = 1'b0;
    reg cs_n_sync_r = 1'b1;
    always @(posedge clk) begin
        sclk_sync_r <= sclk_sync;
        cs_n_sync_r <= cs_n_sync;
    end

    wire count_moment;
    assign count_moment = sclk_sync && !sclk_sync_r;

    reg allow_counting = 1'b0;
    wire select_started;
    wire select_finished;
    assign select_started = !cs_n_sync && cs_n_sync_r;
    assign select_finished = cs_n_sync && !cs_n_sync_r;
    always @(posedge clk) begin
        if (select_started)
            allow_counting <= 1'b1;
        else if (select_finished)
            allow_counting <= 1'b0;
        else 
            allow_counting <= allow_counting;

    end

    wire count_on;
    reg [15:0] cycle_num_reg = 16'd0;
    assign count_on = count_moment && allow_counting;

    always @(posedge clk) begin
        if (count_on) 
            cycle_num_reg <= cycle_num_reg + 1;
        else
            cycle_num_reg <= cycle_num_reg;
    end

    always @(posedge clk) begin
        if (select_finished) begin
            cycles_num <= cycle_num_reg;
            cycles_num_rdy = 1'b1;
        end else begin
            cycles_num = 16'd0;
            cycles_num_rdy <= 1'b0;
        end
    end
endmodule