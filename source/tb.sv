
module tb;
    logic a, b;
    logic y;

    // Instantiate the DUT (Device Under Test)
    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        $display("a b | y");
        a = 0; b = 0; #10; $display("%b %b | %b", a, b, y);
        a = 0; b = 1; #10; $display("%b %b | %b", a, b, y);
        a = 1; b = 0; #10; $display("%b %b | %b", a, b, y);
        a = 1; b = 1; #10; $display("%b %b | %b", a, b, y);
        $finish;
    end
endmodule
