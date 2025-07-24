
module tb;
    logic rst, clk;

    // Instantiate the DUT (Device Under Test)
    rst_gen u1 (
        .rst(rst)
    );

    clk_gen u2 (
        .clk(clk)
    );
endmodule
