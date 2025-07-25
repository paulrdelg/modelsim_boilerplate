// clock generator

module clk_gen(output logic clk);
    timeunit 1ns;
    timeprecision 1ps;

    int   period = 100; // variable delay in nanoseconds

    initial begin
        // Let the simulator know the signal starts unknown
        $display("Initial value of clk = %b", clk);

        #5;

        // Toggle signal once to '1' (could be '0' if preferred)
        clk = 1;
        $display("[%0t] Toggled to: %b", $time, clk);

        forever begin
             #(period/2);
             clk = ~clk;
        end
    end
endmodule
