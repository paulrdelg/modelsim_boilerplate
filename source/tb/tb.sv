// tb

module tb;

    logic rst, clk;
    logic sda, scl;

    // Instantiate the DUT (Device Under Test)
    rst_gen u1 (
        .rst(rst)
    );

    clk_gen u2 (
        .clk(clk)
    );

    i2c_driver u3 (
        .sda(sda),
        .scl(scl)
    );
endmodule
